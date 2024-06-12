#include "evaluator.hh"

namespace ast {
    void Evaluator::visit(const IntegerLiteral& node) {
        value_ = node.value();
    }

    void Evaluator::visit(const BinaryOperator& node) {
        node.left().accept(*this);
        int left = value_;
        node.right().accept(*this);
        int right = value_;
        switch (node.op()) {
            case BinaryOperator::Op::PLUS:
                value_ = left + right;
                break;
            case BinaryOperator::Op::MINUS:
                value_ = left - right;
                break;
            case BinaryOperator::Op::MUL:
                value_ = left * right;
                break;
            case BinaryOperator::Op::DIV:
                if (right == 0) {
                    utils::error(node.location(), "division by zero");
                }
                value_ = left / right;
                break;
            default:
                utils::error(node.location(), "unsupported binary operator in evaluator");
        }
    }

    void Evaluator::visit(const Sequence& node) {
        for (const auto& expr : node.expressions()) {
            expr->accept(*this);
        }
        if (node.expressions().empty()) {
            utils::error(node.location(), "empty sequence in evaluator");
        }
    }

    void Evaluator::visit(const IfThenElse& node) {
        node.condition().accept(*this);
        if (value_) {
            node.thenPart().accept(*this);
        } else {
            node.elsePart().accept(*this);
        }
    }
}
