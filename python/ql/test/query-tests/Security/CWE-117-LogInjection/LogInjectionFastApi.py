#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Log Injection through routed parameters
"""
import logging
import uuid
from enum import Enum
from typing import Annotated, Optional

from fastapi import FastAPI, Path
from pydantic import UUID4

app = FastAPI()

logger = logging.getLogger("test")


class Level(str, Enum):
    low = "low"
    high = "high"


# A routed parameter annotated with a simple type is validated by the framework
# before the request handler runs, so it cannot contain a line break.


@app.get("/pydantic-uuid/{item_id}")
async def pydantic_uuid(item_id: UUID4 = Path(...)):
    logger.warning(f"Item not found: {item_id}")  # Good
    return "ok"


@app.get("/stdlib-uuid/{item_id}")
async def stdlib_uuid(item_id: uuid.UUID):
    logger.warning(f"Item not found: {item_id}")  # Good
    return "ok"


@app.get("/int/{item_id}")
async def int_param(item_id: int):
    logger.info("Item id: %s", item_id)  # Good
    return "ok"


@app.get("/annotated-int/{item_id}")
async def annotated_int_param(item_id: Annotated[int, Path()]):
    logger.info(f"Item id: {item_id}")  # Good
    return "ok"


@app.get("/optional-int/{item_id}")
async def optional_int_param(item_id: Optional[int] = None):
    logger.info(f"Item id: {item_id}")  # Good
    return "ok"


@app.get("/union-int/{item_id}")
async def union_int_param(item_id: int | None = None):
    logger.info(f"Item id: {item_id}")  # Good
    return "ok"


@app.get("/enum/{level}")
async def enum_param(level: Level):
    logger.info(f"Level: {level}")  # Good
    return "ok"


@app.get("/converted/{name}")
async def converted(name: str):
    logger.info(f"Name length: {len(name)}")  # Good
    return "ok"


# A `str` annotation validates nothing, and an unannotated parameter is not
# validated at all, so both remain vulnerable.


@app.get("/str/{name}")
async def str_param(name: str):  # $ Source
    logger.info(f"Name: {name}")  # $ Alert # Bad
    return "ok"


@app.get("/unannotated/{name}")
async def unannotated_param(name):  # $ Source
    logger.info(f"Name: {name}")  # $ Alert # Bad
    return "ok"
