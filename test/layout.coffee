{assert} = require 'chai'
theme = require '../lib/main'

describe 'Layout', ->
  it 'Should include API title & description', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
            title:
              element: 'string'
              content: 'Test API'
          content: [
            {
              element: 'copy'
              content: 'I am a [test](http://test.com/) API.'
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, 'Test API'
      assert.include html, 'I am a <a href="http://test.com/">test</a> API.'
      done()

  it 'Should render custom code in markdown', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
          content: [
            {
              element: 'copy'
              content: 'Test\n\n```coffee\na = 1\n```\n'
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, 'a = <span class="hljs-number">1</span>'
      done()

  it 'Should highlight unfenced code blocks', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
          content: [
            {
              element: 'copy'
              content: 'Test\n\n    var a = 1;\n'
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, '<span class="hljs-attribute">var a</span>'
      done()

  it 'Should auto-link headings in markdown', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
          content: [
            {
              element: 'copy'
              content: '# Custom Heading'
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, '<h1 id="header-custom-heading"'
      assert.include html, '<a class="permalink" href="#header-custom-heading"'
      done()

  it 'Should generate unique header ids', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
          content: [
            {
              element: 'copy'
              content: '# Custom heading\n## Custom heading\n## Custom heading\n'
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, '"header-custom-heading"'
      assert.include html, '"header-custom-heading-1"'
      assert.include html, '"header-custom-heading-2"'
      done()

  it 'Should include API hostname', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
          attributes:
            metadata:
              element: 'array'
              content: [
                {
                  element: 'member'
                  meta:
                    classes:
                      element: 'array'
                      content: [
                        {
                          element: 'string'
                          content: 'user'
                        }
                      ]
                  content:
                    key:
                      element: 'string'
                      content: 'HOST'
                    value:
                      element: 'string'
                      content: 'http://foo.com/'
                }
              ]
          content: []
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, 'http://foo.com/'
      done()

  it 'Should include resource group name & description', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes: {
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
            }
          content: [
            {
              element: 'category'
              meta:
                classes: {
                  element: 'array'
                  content: [
                    {
                      element: 'string'
                      content: 'resourceGroup'
                    }
                  ]
                }
                title:
                  element: 'string'
                  content: 'Frobs'
              content: [
                {
                  element: 'copy'
                  content: 'A list of <em>Frobs</em>'
                }
              ]
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, 'Frobs'
      assert.include html, 'A list of <em>Frobs</em>'
      done()

  it 'Should include resource information', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes:
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
          content: [
            {
              element: 'category'
              meta:
                classes: {
                  element: 'array'
                  content: [
                    {
                      element: 'string'
                      content: 'resourceGroup'
                    }
                  ]
                }
                title:
                  element: 'string'
                  content: 'Frobs'
              content: [
                {
                  element: 'resource'
                  meta:
                    title:
                      element: 'string'
                      content: 'Test Resource'
                  content: [
                    {
                      element: 'copy'
                      content: 'Test *description*'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, 'Test Resource'
      assert.include html, 'Test <em>description</em>'
      done()

  it 'Should include action information', (done) ->
    refract =
      element: 'parseResult'
      content: [
        {
          element: 'category'
          meta:
            classes:
              element: 'array'
              content: [
                {
                  element: 'string'
                  content: 'api'
                }
              ]
          content: [
            {
              element: 'category'
              meta:
                classes: {
                  element: 'array'
                  content: [
                    {
                      element: 'string'
                      content: 'resourceGroup'
                    }
                  ]
                }
                title:
                  element: 'string'
                  content: 'TestGroup'
              content: [
                {
                  element: 'resource'
                  meta:
                    title:
                      element: 'string'
                      content: 'TestResource'
                  attributes:
                    href:
                      element: 'string'
                      content: '/resource/{idParam}{?param%2Dname*}'
                  content: [
                    {
                      element: 'transition'
                      meta:
                        title:
                          element: 'string'
                          content: 'Test Action'
                      attributes:
                        hrefVariables:
                          element: 'hrefVariables'
                          content: [
                            {
                              element: 'member',
                              meta:
                                description:
                                  element: 'string'
                                  content: 'Id parameter description'
                              attributes:
                                typeAttributes:
                                  element: 'array'
                                  content: [
                                    {
                                      element: 'string'
                                      content: 'required'
                                    }
                                  ]
                              content:
                                key:
                                  element: 'string'
                                  content: 'idParam'
                                value:
                                  element: 'string'
                            },
                            {
                              element: 'member',
                              meta:
                                title:
                                  element: 'string'
                                  content: 'boolean'
                                description:
                                  element: 'string'
                                  content: 'Param *description*'
                              attributes:
                                typeAttributes:
                                  element: 'array'
                                  content: [
                                    {
                                      element: 'string'
                                      content: 'required'
                                    }
                                  ]
                              content:
                                key:
                                  element: 'string'
                                  content: 'param-name'
                                value:
                                  element: 'enum'
                                  attributes:
                                    enumerations:
                                      element: 'array'
                                      content: [
                                        {
                                          element: 'string'
                                          content: 'test%2Dchoice'
                                        }
                                      ]
                                  content: 'test%2Dchoice'
                            },
                          ]
                      content: [
                        {
                          element: 'copy'
                          content: 'Test *description*'
                        },
                        {
                          element: 'httpTransaction'
                          content: [
                            {
                              element: 'httpRequest'
                              attributes:
                                method:
                                  element: 'string'
                                  content: 'GET'
                              content: []
                            },
                            {
                              element: 'httpResponse'
                              attributes:
                                statusCode:
                                  element: 'string'
                                  content: '200'
                              content: [
                                {
                                  element: 'asset'
                                  meta:
                                    classes:
                                      element: 'array'
                                      content: [
                                        {
                                          element: 'string'
                                          content: 'messageBody'
                                        }
                                      ]
                                  content: '{"error": true}'
                                }
                              ]
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]

    theme.render refract, (err, html) ->
      if err then return done err
      assert.include html, 'Test Action'
      assert.include html, 'Test <em>description</em>'
      assert.include html, 'GET'
      assert.include html, '/resource/{idParam}{?param-name*}'
      assert.include html, 'idParam'
      assert.include html, 'Id parameter description'
      assert.include html, 'param-name'
      assert.include html, 'Param <em>description</em>'
      assert.include html, 'bool'
      assert.include html, 'required'
      assert.include html, 'true'
      assert.include html, 'test-choice'
      done()
