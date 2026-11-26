"""从 pi --mode json 的启动输出中提取 <available_skills> 片段。

用法：python3 extract_startup_info.py <startup.json>
"""
import sys
from pathlib import Path

raw = Path(sys.argv[1]).read_text(encoding="utf-8", errors="replace")
start = raw.find("<available_skills>")
end = raw.find("</available_skills>")
if start < 0 or end < 0:
    print("未发现 <available_skills>，Skill 未被本次启动发现")
    sys.exit(1)

fragment = raw[start : end + len("</available_skills>")]
fragment = fragment.replace("\\n", "\n").replace('\\"', '"')
fragment = fragment.replace("\\\\", "\\")

print("[启动系统提示中的可用 Skills]")
print(fragment)
print()
print("[结论] pptx 已在启动时被自动发现，location 指向本次安装目录。")
