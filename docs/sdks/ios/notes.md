# iOS notes

## Swift

--8<-- "herald-ios/README.md:differences"

## Failures

- **Each failure reaches the error reporter as soon as its vendor reports it,** on the thread that
  made the call, not after every vendor has finished.
- **Your own provider must return quickly,** because Herald calls each provider on your thread and
  waits for it. See [Custom providers](../../guides/custom-provider.md#your-own-backend).
