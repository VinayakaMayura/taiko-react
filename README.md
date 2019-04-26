# taiko-react [![Build Status](https://travis-ci.org/taiko-react/taiko-react.svg?branch=master)](https://travis-ci.org/taiko-react/taiko-react) [![Coverage Status](https://coveralls.io/repos/github/taiko-react/taiko-react/badge.svg?branch=master)](https://coveralls.io/github/taiko-react/taiko-react?branch=master) [![Known Vulnerabilities](https://snyk.io/test/github/tkshnwesper/taiko-react/badge.svg?targetFile=package.json)](https://snyk.io/test/github/tkshnwesper/taiko-react?targetFile=package.json)

`taiko-react` allows you to select React components on the webpage that you want to perform tests on.

It uses [resq](https://github.com/baruchvlz/resq) to find the React components.

## Pre-requisites

1. The webpage that is being tested needs to be using React.
2. React needs to be running in development mode (not production).

## Install

```Shell
npm i taiko-react
```

## Usage

Load up the plugin and navigate to the React powered webpage ⚡️

```js
const { openBrowser, goto, loadPlugin } = require('taiko')
const { ID, clientHandler, react } = require('taiko-react')

await loadPlugin(ID, clientHandler)

await openBrowser()
await goto("http://localhost:8080")
```

Now you may use various selectors to find React elements on the page 🔎

### Select using a **string** selector

```js
const selection = await react('App')
```

### Select using a **React component**

```jsx
const selection = await react(<App />)
```

## API

### `.exists()` _-> `Boolean`_

```jsx
const selection = await react(<App />)

assert(selection.exists())
```

### `.length()` _-> `Number`_

```jsx
const list = await react(<List />)
const listItem = await react(<ListItem />, { multiple: true })

assert(list.length() === 1)
assert(listItem.length() === 3)
```

## Functional tests

### Status

[![Build Status](https://travis-ci.org/taiko-react/taiko-react-functional-tests.svg?branch=master)](https://travis-ci.org/taiko-react/taiko-react-functional-tests)

### Repository

[taiko-react/taiko-react-functional-tests](https://github.com/taiko-react/taiko-react-functional-tests)

Made with 💟 + ☕️ from 🇮🇳