# 使用指南

1. 改 `docs/` 里的 Markdown 文件。
2. 本地预览，检查导航、表格、代码块和页面之间的链接。
3. 提交并推到 main。
4. 去仓库的 Actions 页看这次跑成功没有。
5. 打开网站刷新，确认文字变了。

## 常用命令

```bash
python -m venv .venv
source .venv/Scripts/activate
python -m pip install -r requirements.txt
python -m mkdocs build --strict
python -m mkdocs serve
```

`serve` 默认在 `http://127.0.0.1:8000/` 起一个本地服务，按 Ctrl+C 停掉。`--strict` 会把警告也当错误，比如 `nav` 里写了不存在的页面、或者链接指不到文件，构建就直接失败，比等到线上才发现要好。

## 我这边的两个小坑

这台机器 `git push` 要带 `-c http.sslBackend=openssl`，不然 schannel 会报证书吊销检查离线。另外 PowerShell 里激活虚拟环境常被脚本执行策略拦住，我直接用 Git Bash 的 `source .venv/Scripts/activate`，没有去改系统策略。

还有一点容易忽略：只改 `report/README.md` 或根目录 README 不会触发部署，因为工作流的 `paths` 只列了 `docs/**`、`mkdocs.yml`、`requirements.txt` 和工作流自己。要验证自动更新，得改 `docs/` 里的内容。

相关页面：[首页](index.md)、[关于](about.md)、[API 参考](api.md)。
