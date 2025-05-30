## drift 离线优先开发计划

- 先实现 drift 本地存储和 UI 逻辑。
- 再实现同步队列和后台同步机制。
- 最后对接 D1 后端 API，完善冲突处理和异常处理。

## 监听 drift 的指令

```bash
dart run build_runner watch
```
