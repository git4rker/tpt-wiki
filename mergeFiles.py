#!/usr/bin/env python

import re
import os

# No support for scripts in directories yet, you do it git4rker or smth
def processFile(path, imported = []):
    regex = r"^local (.+) = require\([\"'](.*)[\"']\)"

    with open(path, "r") as file:
        content = file.read()
        for match in re.findall(regex, content, re.MULTILINE):
            (moduleName, modulePath) = match

            if moduleName in imported:
                content = re.sub(
                    r"^local " + re.escape(moduleName) + r" = require\([\"']" + re.escape(modulePath) + r"[\"']\)",
                    "--ignoring " + moduleName + " reimport ",
                    content,
                    flags=re.MULTILINE
                )
                continue

            imported.append(moduleName)

            content = re.sub(
                r"^local " + re.escape(moduleName) + r" = require\([\"']" + re.escape(modulePath) + r"[\"']\)",
                "--#region " + moduleName + "\n" + processFile(os.path.join(os.path.dirname(path), modulePath + ".lua"), imported).replace("\\", "\\\\"),
                content,
                flags=re.MULTILINE 
            )

            content = re.sub(r"^return " + re.escape(moduleName), "--#endregion " + moduleName, content, flags=re.MULTILINE)


    return content


with open("./PowderWiki.lua", "w") as file:
    file.write(processFile("./src/wiki.lua"))