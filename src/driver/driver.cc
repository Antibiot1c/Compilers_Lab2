#include "../ast/evaluator.hh"

// Inside the main function, after parsing the input
if (vm.count("eval")) {
    if (vm.count("dump-ast")) {
        utils::error("Cannot use --eval with --dump-ast");
        return 1;
    }
    ast::Evaluator evaluator;
    program->accept(evaluator);
    std::cout << evaluator.result() << std::endl;
    return 0;
}
