#pragma once
#include "stdafx.h"
#include "Core/Tokens/TokenBase.hpp"
#include "Core/Backus/BackusRuleBase.h"
#include "Core/Generator/GeneratorItemBase.h"

class While : public TokenBase<While>, public BackusRuleBase<While>, public GeneratorItemBase<While>
{
    BASE_ITEM

public:
    While() { setLexeme("WHILE"); };
    virtual ~While() = default;

    void genCode(std::ostream& out, GeneratorDetails& details,
        std::list<std::shared_ptr<IGeneratorItem>>::iterator& it,
        const std::list<std::shared_ptr<IGeneratorItem>>::iterator& end) const final
    {
        if (customData("noGenerateCode") == "true")
        {
            return;
        }

        if (customData("ContinueWhile") == "true")
        {
            out << "\tjmp " << customData("startLabel") << std::endl;
            return;
        }

        if (customData("ExitWhile") == "true")
        {
            out << "\tjmp " << customData("endLabel") << std::endl;
            return;
        }

        it++;
        auto postForm = GeneratorUtils::Instance()->ConvertToPostfixForm(it, end);

        out << customData("startLabel") << ":" << std::endl;

        auto postIt = postForm.begin();
        auto postEnd = postForm.end();
        for (const auto& item : postForm)
            item->genCode(out, details, postIt, postEnd);

        

        out << "\tpop " << details.args().regPrefix << "ax" << std::endl;
        out << "\tcmp " << details.args().regPrefix << "ax, 0" << std::endl;
        out << "\tje " << customData("endLabel") << std::endl;
    };
};