#!/usr/bin/env python

import re
import os
import sys

in_path = sys.argv[1] if len(sys.argv) >= 2 else "./src/wiki.lua"
out_path = sys.argv[2] if len(sys.argv) >= 3 else "PowderWiki.lua"

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


with open(out_path, "w") as file:
    file.write(processFile(in_path))