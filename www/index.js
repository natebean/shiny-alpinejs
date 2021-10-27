document.addEventListener('alpine:init', () => {
    Alpine.data('index', () => ({
      value: 'index Data Object',
      includeValue:  'Alpine + Shiny + Include'
    }))
    Alpine.data('indexA', () => ({
      value: 'indexA Data Object'
    }))
})