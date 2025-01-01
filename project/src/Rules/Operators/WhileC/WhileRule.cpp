#include "stdafx.h"
#include "WhileRule.h"

#include "Rules/Operators/WhileC/While.h"

#include "SimpleTokens.h"

SimpleToken(ExitWhile, "EXIT")
SimpleToken(ContinueWhile, "CONTINUE")

BackusRulePtr MakeWhile(std::shared_ptr<Controller> controller)
{
    controller->regItem<While>();
    controller->regItem<ExitWhile>();
    controller->regItem<ContinueWhile>();

    auto context = controller->context();
    static const auto [lStart, lCodeBlok, lEnd] = context->CodeBlockTypes();
    auto operatorsRuleName = context->OperatorsRuleName();
    auto operatorsName = context->OperatorsName();
    auto operatorsWithSemicolonsName = context->OperatorsWithSemicolonsName();

    auto whileExitStatement = controller->addRule("WhileExitStatement", {
       BackusRuleItem({           ExitWhile::Type()}, OnlyOne),
       BackusRuleItem({              While::Type()}, OnlyOne)
        });

    auto whileContinueStatement = controller->addRule("WhileContinueStatement", {
       BackusRuleItem({           ContinueWhile::Type()}, OnlyOne),
       BackusRuleItem({              While::Type()}, OnlyOne)
        });

    auto whileCStatement = controller->addRule("WhileStatement", {
       BackusRuleItem({              While::Type()}, OnlyOne),
       BackusRuleItem({           Symbols::LBraket}, OnlyOne),
       BackusRuleItem({ context->EquationRuleName()}, OnlyOne),
       BackusRuleItem({           Symbols::RBraket}, OnlyOne),
       BackusRuleItem({              Start::Type()}, OnlyOne),
       BackusRuleItem({ operatorsName, operatorsWithSemicolonsName,whileContinueStatement->type(), whileExitStatement->type()}, Optional | OneOrMore),
       BackusRuleItem({                 End::Type()}, OnlyOne),
       BackusRuleItem({              While::Type()}, OnlyOne),
        });

    whileCStatement->setPostHandler([](BackusRuleList::iterator& ruleBegin,
        BackusRuleList::iterator& it,
        BackusRuleList::iterator& end)
    {
        static size_t index = 0;
        index++;

        std::string startLabel = std::format("whileStart{}", index);
        std::string endLabel = std::format("whileEnd{}", index);

        (*ruleBegin)->setCustomData(startLabel, "startLabel");
        (*ruleBegin)->setCustomData(endLabel, "endLabel");



        size_t count = 0;
        for (auto itr = ruleBegin; itr != it; ++itr)
        {
            auto type = (*itr)->type();

            if (type == lEnd && itr != it && (*std::next(itr, 1))->type() == While::Type())
            {
                (*std::next(itr, 1))->setCustomData("true", "noGenerateCode");
            }

            if (type == lStart)
            {
                count++;
            }
            else if (type == lEnd && count == 1)
            {
                (*itr)->setCustomData(std::format("\tjmp {}\n{}:", startLabel, endLabel));
                break;
            }
            else if (type == ExitWhile::Type() && count == 1 && itr != it && (*std::next(itr, 1))->type() == While::Type())
            {
                itr++;
                (*itr)->setCustomData("true", "ExitWhile");
                (*itr)->setCustomData(endLabel, "endLabel");
            } 
            else if(type == ContinueWhile::Type() && count == 1 && itr != it && (*std::next(itr, 1))->type() == While::Type())
            {
                itr++;
                (*itr)->setCustomData("true", "ContinueWhile");
                (*itr)->setCustomData(startLabel, "startLabel");
            }
            else if (type == lEnd && count > 0)
            {
                count--;
            }

        }
    });

    return whileCStatement;
}