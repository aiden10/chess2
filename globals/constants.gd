extends Node

const TILE_SIZE: int = 64
const HOVER_COLOR_ALPHA = 0.2
const SPRITE_SIZE: float = 1.25
const VALID_MOVE_TILE_COLOR = Color.AQUAMARINE
const VALID_ATTACK_TILE_COLOR = Color.CRIMSON
const VALID_ABILITY_TILE_COLOR = Color.DARK_VIOLET

const SERVER_URL: String = "http://127.0.0.1:8000/"
const SOCKET_URL: String = "ws://127.0.0.1:8000/ws"

var pieces_dict = {
	Piece.PieceType.PAWN: Pawn,
	Piece.PieceType.ROOK: Rook,
	Piece.PieceType.KNIGHT: Knight,
	Piece.PieceType.BISHOP: Bishop,
	Piece.PieceType.QUEEN: Queen,
	Piece.PieceType.KING: King,
	Piece.PieceType.WALL: Wall
}

const PAWN_HP = 2
const PAWN_STRENGTH = 1
const PAWN_RANGE = 1

const BISHOP_HP = 5
const BISHOP_STRENGTH = 3
const BISHOP_RANGE = 2

const KNIGHT_HP = 4
const KNIGHT_STRENGTH = 2

const ROOK_HP = 5
const ROOK_STRENGTH = 3
const ROOK_RANGE = 2

const QUEEN_HP = 8
const QUEEN_STRENGTH = 4
const QUEEN_RANGE = 2

const KING_HP = 12
const KING_STRENGTH = 5
const KING_RANGE = 1

const WALL_HP = 3
const WALL_STRENGTH = 0
const WALL_RANGE = 0
