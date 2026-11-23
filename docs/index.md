# 我的技术文档

这是 feng02work 仓库里的几页笔记，用 MkDocs 编译成网页，再由 GitHub Actions 发到 GitHub Pages。

- 作者：Li0Fong1
- 实践主题：静态文档自动部署
- [关于本项目](about.md)
- [使用指南](guide.md)
- [API 参考](api.md)

## 为什么做这个

我记笔记一直用本地 Markdown，文件一多就不好找，也不方便把链接直接发给别人。所以想把 `docs/` 里的几页文字变成一个打开就能看的网页：文档照旧写 Markdown，`mkdocs.yml` 管导航和主题，本地跑一次 `mkdocs build` 生成 `site/`，推到 main 之后由工作流把 `site/` 上传发布。

第一次配环境卡了一会儿。本机 git 走 Windows 的 schannel 连 GitHub 会报 `CRYPT_E_REVOCATION_OFFLINE`，换成 openssl 后端才连上；另外这台机器装的是 Python 3.13，而工作流里指定的是 3.12，两边版本不一样，但构建本身没受影响。经过记在仓库的 `report/README.md` 里。

页面不多，四页分别是首页、[关于](about.md)、[使用指南](guide.md) 和 [API 参考](api.md)。API 那页只是练着写接口说明，后面没有真服务。
