from fastapi import Security, HTTPException, status
from fastapi.security.api_key import APIKeyHeader
from typing import Optional
import os
import secrets

API_KEY_NAME = "X-API-Key"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

def get_api_key() -> str:
    """Generate a secure API key if not already set"""
    api_key = os.getenv("API_KEY")
    if not api_key:
        api_key = secrets.token_urlsafe(32)
        print(f"Generated API Key: {api_key}")
    return api_key

async def verify_api_key(api_key_header: Optional[str] = Security(api_key_header)) -> bool:
    """Verify the API key from the request header"""
    if api_key_header is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="API Key missing"
        )
    
    if api_key_header != os.getenv("API_KEY"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid API Key"
        )
    
    return True
