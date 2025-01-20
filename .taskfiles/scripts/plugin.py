from typing import Any

from typing import Any

import makejinja

import base64

import os


def b64encode(value: str) -> str:
    string_bytes = value.encode("ascii")
    base64_bytes = base64.b64encode(string_bytes)
    return base64_bytes.decode("ascii")


def get_env(value: str) -> str:
    env = os.getenv(value)
    if env is None:
        raise Exception(f"Environment variable '{value}' cannot be found.")
    return env


def domain2dn(value: str) -> str:
    return ",".join(list(map(lambda x: f'dc={x}', value.split("."))))

class Plugin(makejinja.plugin.Plugin):
    def __init__(self, data: dict[str, Any], config: makejinja.config.Config):
        self._data = data
        self._config = config


    def filters(self) -> makejinja.plugin.Filters:
        return [b64encode, domain2dn]


    def functions(self) -> makejinja.plugin.Functions:
        return [get_env]


    def path_filters(self):
        return []
