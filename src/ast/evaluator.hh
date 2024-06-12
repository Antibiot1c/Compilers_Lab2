#ifndef AST_EVALUATOR_HH
#define AST_EVALUATOR_HH

#include "nodes.hh"
#include "const-visitor.hh"
#include "../utils/errors.hh"

namespace ast {
    class Evaluator : public ConstASTIntVisitor {
    public:
        void visit(const IntegerLiteral& node) override;
        void visit(const BinaryOperator& node) override;
        void visit(const Sequence& node) override;
        void visit(const IfThenElse& node) override;
        // Handle other nodes as errors
        void visit(const Node& node) override {
            utils::error(node.location(), "unsupported node in evaluator");
        }
        int result() const { return value_; }
    private:
        int value_;
    };
}

#endif
