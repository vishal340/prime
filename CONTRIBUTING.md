# Contributing Guidelines

## Code Style

- Use clear, descriptive variable names
- Add comments explaining non-obvious mathematical operations
- Follow C++11 standard or later
- Use `const` where appropriate
- Prefer `std::vector` over raw arrays

## Documentation Requirements

When adding a new program:

1. **Add file header comment** explaining purpose and algorithm
2. **Document input/output format** 
3. **Add main logic comments** for mathematical operations
4. **Update README.md** with program description
5. **Include complexity analysis** if applicable

## Commit Messages

Use clear, descriptive commit messages:
- `feat: add new algorithm for X analysis`
- `docs: improve comments in calc1.cpp`
- `fix: correct overflow in consecutive_zeros.cpp`

## Testing

- Test programs with provided example inputs
- Verify output format matches documentation
- Check for memory leaks using valgrind for larger inputs

## Pull Request Process

1. Create a feature branch
2. Make changes with appropriate comments
3. Update documentation
4. Test thoroughly
5. Submit PR with clear description

## Areas for Contribution

- Algorithm implementations
- Documentation improvements
- Performance optimizations
- Test suite development
- Visualization tools
