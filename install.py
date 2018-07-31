#!/usr/bin/env python3

# dotfiles以下のファイル郡を~/以下にシンボリックリンクで展開する。
# 実行フォルダはどこでもよい。

import os
import shutil
from datetime import datetime

script_dir = os.path.abspath(os.path.dirname(__file__))
os.chdir(script_dir)
backup_dir = os.path.join(os.environ['HOME'], 'dotfiles_bak/')
os.makedirs(backup_dir, exist_ok=True)
now = datetime.now().strftime("%Y%m%d%H%M%s")

exclude_list = [
    ".gitignore",
    "README.md",
    "install.sh",
    "install.py",
]


def list_files(path="."):
    res = []
    for root, dirs, files in os.walk(path):
        for filename in files:
            res.append(os.path.join(root, filename)[2:])
    return res


if __name__ == '__main__':
    for filepath in list_files("."):
        filename = filepath[filepath.rfind("/")+1:]
        if ".git/" in filepath:
            continue
        if filepath in exclude_list:
            continue

        print("----------------------")
        print("installing: " + filepath + " .....")
        src = os.path.join(script_dir, filepath)

        target = os.path.join(os.environ['HOME'], filepath)
        target_dir = target[:target.rfind("/")+1]
        os.makedirs(target_dir, exist_ok=True)
        target_backup = os.path.join(backup_dir, filename + "_" + now)
        if os.path.lexists(target):
            shutil.move(target, target_backup,)
            print("backuped: " + target_backup)

        os.symlink(src, target)
        print("linked: " + target + " to " + src)
        print("----------------------\n")
