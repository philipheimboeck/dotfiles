return {
    {
        'huggingface/llm.nvim',
        opts = {
            backend = 'ollama',
            model = 'codeqwen:7b',
            url = "http://localhost:11434",
            request_body = {
                -- Modelfile options for the model you use
                options = {
                    temperature = 0.2,
                    top_p = 0.95,
                }
            },
            lsp = {
                bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
            },
        }
    },
}
