# feng02work

MkDocs 文档 + GitHub Actions 自动部署到 GitHub Pages 的练习仓库。四页文档放在 `docs/`，过程记录见 [个人实验报告](report/README.md)。

- 源码仓库：https://github.com/Li0Fong1/feng02work
- 公开网站：https://li0fong1.github.io/feng02work/
- 报告：[report/README.md](report/README.md)

## 本地预览

```bash
python -m venv .venv
source .venv/Scripts/activate
python -m pip install -r requirements.txt
python -m mkdocs serve
```

浏览器打开 http://127.0.0.1:8000/ 逐页检查。`mkdocs build --strict` 可以先把警告当错误跑一遍。构建产物 `site/` 不提交到仓库。

这台机器上 git 走 Windows schannel 会报证书吊销离线，push 时加 `-c http.sslBackend=openssl` 即可，细节写在报告里。
