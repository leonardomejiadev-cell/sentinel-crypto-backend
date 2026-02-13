from fastapi import APIRouter, HTTPException
from psycopg2.extras import RealDictCursor

from app.infrastructure.database import db

router = APIRouter(
    prefix="/api/v1",
    tags=["portfolio"],
    responses={404: {"description": "Not found"}},
)


@router.get("/portfolio/{username}")
def get_portfolio(username: str):
    """
    Obtiene el portafolio de un usuario.
    
    Args:
        username: Nombre de usuario
        
    Returns:
        dict: Portafolio del usuario con sus monedas y cantidades
    """
    conn = db.get_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")

    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(
            "SELECT * FROM view_user_portfolio WHERE username = %s", (username,)
        )
        portfolio = cur.fetchall()

        cur.close()
        conn.close()

        if not portfolio:
            raise HTTPException(status_code=404, detail="User not found")

        return {"username": username, "portfolio": portfolio}

    except Exception as e:
        conn.close()
        raise HTTPException(status_code=500, detail=str(e))
