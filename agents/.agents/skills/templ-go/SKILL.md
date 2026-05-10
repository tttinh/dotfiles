---
name: templ-go
description: Write Go templ components and pages using templ and templui. Use when user is writing .templ files, building templ components, using templui UI components, or working with Go HTML templating via templ.
---

# templ + templui

Write Go HTML components using [templ](https://github.com/a-h/templ) and [templui](https://github.com/templui/templui).

## Quick start

```templ
package views

templ Hello(name string) {
  <h1>Hello, { name }</h1>
}
```

## Syntax

- `.templ` files compile to Go functions returning `templ.Component`
- Uppercase = exported, lowercase = unexported (same as Go)
- `@Component()` to compose; `{ expression }` for escaped text output
- Children: `{ children... }` in parent, `@Parent() { <child/> }` at call site
- CSS classes: `class={ "name", templ.KV("active", isActive) }`

```templ
// Conditionals
if condition {
  <div>shown</div>
} else {
  <div>hidden</div>
}

// Loops
for _, item := range items {
  <li>{ item.Name }</li>
}

// Switch
switch status {
  case "active":
    <span>Active</span>
  default:
    <span>Unknown</span>
}

// Composition
templ Page() {
  @Layout() {
    @Header()
    <main>{ children... }</main>
  }
}
```

## templui components

Import from `github.com/templui/templui/components/<name>`.

```templ
import "github.com/templui/templui/components/button"
import "github.com/templui/templui/components/card"
import "github.com/templui/templui/components/input"

templ LoginForm() {
  @card.Card() {
    @card.Header() {
      @card.Title() { Login }
    }
    @card.Content() {
      @input.Input(input.Props{
        Type:        input.TypeEmail,
        Placeholder: "Email",
      })
      @input.Input(input.Props{
        Type:        input.TypePassword,
        Placeholder: "Password",
      })
    }
    @card.Footer() {
      @button.Button() { Sign In }
    }
  }
}
```

See [templui-reference.md](templui-reference.md) for the full component catalog.

## Security

- `on*` attributes require `templ.ComponentScript` (use `script` blocks)
- `href` expressions: use `templ.URL()` or `templ.SafeURL()`
- `style` attributes cannot be expressions; use `css` blocks
- `<script>`/`<style>` tags only accept static content

## References

- [templ-reference.md](templ-reference.md) — full templ language guide
- [templui-reference.md](templui-reference.md) — templui component catalog
