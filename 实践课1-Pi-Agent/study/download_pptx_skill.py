"""实践课任务六：从 anthropics/skills 下载 skills/pptx 完整目录。

由 AI 编写并执行，用于把 PPT Skill 安装到当前项目的 .pi/skills/pptx。
- 保留 SKILL.md、LICENSE.txt、scripts 等全部支持文件（不是只复制 SKILL.md）
- 固定到同一个源 commit，保证所有文件版本一致
- 不修改其他项目、不自动安装依赖

运行：python download_pptx_skill.py
"""
import json
import urllib.request
from pathlib import Path

REPO = "anthropics/skills"
REF = "main"
SRC_PREFIX = "skills/pptx/"
HERE = Path(__file__).resolve().parent
DEST = HERE / ".pi" / "skills" / "pptx"


def fetch(url: str, as_json: bool = True):
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": "pi-practice-course-1",
            "Accept": "application/vnd.github+json",
        },
    )
    with urllib.request.urlopen(req, timeout=40) as resp:
        data = resp.read()
    return json.loads(data) if as_json else data


def main():
    commit = fetch(f"https://api.github.com/repos/{REPO}/commits/{REF}")["sha"]
    print(f"源 commit: {commit}")

    tree = fetch(f"https://api.github.com/repos/{REPO}/git/trees/{commit}?recursive=1")
    if tree.get("truncated"):
        raise SystemExit("目录树被截断，请改用 tarball 方式下载")

    files = [
        item
        for item in tree["tree"]
        if item["type"] == "blob" and item["path"].startswith(SRC_PREFIX)
    ]
    print(f"skills/pptx 下共 {len(files)} 个文件，开始下载到 {DEST}")

    for item in files:
        rel = item["path"][len(SRC_PREFIX) :]
        target = DEST / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        url = f"https://raw.githubusercontent.com/{REPO}/{commit}/{item['path']}"
        target.write_bytes(fetch(url, as_json=False))
        print(f"  + {rel}")

    (HERE / "source-commit.txt").write_text(
        f"repo: https://github.com/{REPO}\n"
        f"ref: {REF}\n"
        f"commit: {commit}\n"
        f"source dir: {SRC_PREFIX}\n"
        f"files: {len(files)}\n",
        encoding="utf-8",
    )
    print(f"完成：{len(files)} 个文件，commit 已记录到 source-commit.txt")


if __name__ == "__main__":
    main()
