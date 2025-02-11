local php_namespace = require("./namespace")

return {
    php = {
        {
            trigger = 'php',
            body = '<?php\n\nnamespace ${NAMESPACE};\n\n${1|class,interface,enum|} ${TM_FILENAME_BASE}\n{\n$0\n}',
            --- @param body string
            substitute = function(body)
                return body:gsub("${NAMESPACE}", php_namespace.generate_namespace() or '')
            end
        },
        {
            trigger = 'ctr',
            body = 'public function __construct() {}'
        },
        {
            trigger = 'fun',
            body = '${1|public,private,protected|} function ${2:name}($3): ${4:void}\n{$0\n}',
        },
        {
            trigger = 'setup',
            body = '#[\\Override]\npublic function setUp(): void\n{\nparent::setUp();\n}',
        },
        {
            trigger = 'levent',
            body =
            [[<?php

namespace ${NAMESPACE};

use Illuminate\Contracts\Events\ShouldDispatchAfterCommit;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * @method static mixed dispatch(${1:params})
 */
class ${TM_FILENAME_BASE} implements ShouldDispatchAfterCommit
{
    use Dispatchable;
    use SerializesModels;

    public function __construct(${1:params})
    {
    }
}
]],
            --- @param body string
            substitute = function(body)
                return body:gsub("${NAMESPACE}", php_namespace.generate_namespace() or '')
            end
        }
    }
}
