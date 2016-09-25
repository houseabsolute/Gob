module.exports = {
    root: true,
    env: {
        browser: true,
        es6: true,
        jasmine: true,
        jquery: true,
    },
    extends: [
        'airbnb-base',
    ],
    globals: {
        getJSONFixture: true,
        inject: false,
        loadJSONFixtures: true,
        module: false,
    },
    parser: 'babel-eslint',
    parserOptions: {
        sourceType: 'module',
    },
    plugins: [
        'flowtype',
    ],
    rules: {
        'func-names': [
            'off',
        ],
        indent: [
            'error',
            4,
        ],
        'linebreak-style': [
            'error',
            'unix',
        ],
        'no-underscore-dangle': [
            'off',
        ],
        'no-var': [
            'warn',
        ],
        'prefer-arrow-callback': [
            'warn',
        ],
        quotes: [
            'error',
            'single',
        ],
        semi: [
            'error',
            'always',
        ],
    },
};
