from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import JSONResponse
from typing import List, Dict, Optional
import json

app = FastAPI()

class Room:
    def __init__(self, name: str, password: str):
        self.name = name
        self.password = password
        self.players: List[Player] = []
        self.game_state: Dict = {
            "turn": 0,
            "selected_piece": {},
            "selected_ability": {},
        }
        self.board_state: Dict = {}
        
    async def broadcast(self, message: Dict) -> None:
        """Broadcast message to all players in room"""
        for player in self.players:
            await player.socket.send_json(message)
            
    def get_player_color(self, player) -> Optional[str]:
        """Get player's color based on join order"""
        if player == self.players[0]:
            return 0
        elif player == self.players[1]:
            return 1
        return None

class Player:
    def __init__(self, socket: WebSocket, room_name: str):
        self.socket = socket
        self.room_name = room_name
        self.color = None

rooms: Dict[str, Room] = {}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    player: Optional[Player] = None
    room: Optional[Room] = None
    
    try:
        while True:
            if not player:
                # Handle authentication
                try:
                    room_info = await websocket.receive_json()
                    room_name = room_info["room_name"]
                    password = room_info["password"]
                    
                    if room_name not in rooms:
                        await websocket.send_json({"type": "error", "message": "Room not found"})
                        continue
                        
                    room = rooms[room_name]
                    if room.password != password:
                        await websocket.send_json({"type": "error", "message": "Invalid password"})
                        continue
                        
                    if len(room.players) >= 2:
                        await websocket.send_json({"type": "error", "message": "Room is full"})
                        continue
                    
                    # Create and add player
                    player = Player(websocket, room_name)
                    room.players.append(player)
                    player.color = room.get_player_color(player)
                    
                    # Send initial state
                    await websocket.send_json({
                        "type": "connected",
                        "color": player.color,
                        "game_state": room.game_state,
                        "board_state": room.board_state
                    })
                    
                    # If room is full, start the game
                    if len(room.players) == 2:
                        await room.broadcast({
                            "type": "game_start",
                            "game_state": room.game_state
                        })
                        
                except json.JSONDecodeError:
                    await websocket.send_json({"type": "error", "message": "Invalid JSON"})
                    continue
                    
            # Handle actual game 
            else:
                data = await websocket.receive_json()
                if data["type"] == "move":
                    if room.game_state["turn"] != player.color:
                        await websocket.send_json({"type": "error", "message": "Not your turn"})
                        continue

                    # Update game state
                    room.game_state = data["game_state"]
                    room.board_state = data["board_state"]
                    
                    # Broadcast the move to all players
                    await room.broadcast({
                        "type": "state_update",
                        "game_state": room.game_state,
                        "board_state": room.board_state
                    })
                    
    except WebSocketDisconnect:
        if player and room:
            room.players.remove(player)
            if room.players:
                await room.broadcast({
                    "type": "player_disconnected",
                    "message": f"Player {player.color} disconnected"
                })

@app.post("/create_room")
async def create_room(request: dict):
    try:
        name = request["name"]
        password = request["password"]
        
        if name in rooms:
            return JSONResponse(
                content={"message": "Room already exists"},
                status_code=400
            )
            
        room = Room(name, password)
        rooms[name] = room
        return JSONResponse(
            content={"message": "Room created successfully"},
            status_code=200
        )
        
    except Exception as e:
        return JSONResponse(
            content={"message": str(e)},
            status_code=400
        )

@app.get("/rooms")
async def get_rooms():
    room_list = [
        {
            "name": room.name,
            "player_count": len(room.players)
        }
        for room in rooms.values()
    ]
    return JSONResponse(content={"rooms": room_list})