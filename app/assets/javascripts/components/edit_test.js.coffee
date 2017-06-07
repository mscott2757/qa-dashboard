@EditTest = React.createClass
  getInitialState: ->
    edit: false

  getDefaultProps: ->
    applications: []
    environments: []

  applicationTagsFormat: ->
    app_tag_names = @props.test.application_tags.map (app_tag) -> app_tag.name
    app_tag_names.join()

  bindAutocomplete: ->
    appNames = @props.applications.map (app) -> app.name
    testID = @props.test.id
    $ ->
      split = (val) ->
        val.split( /,\s*/ )

      extractLast = (term) ->
        split(term).pop()

      $("#tags-#{ testID }").on("keydown", (e) ->
          if e.keyCode == $.ui.keyCode.TAB and $(this).autocomplete("instance").menu.active
            e.preventDefault()
        ).autocomplete
          minLength: 0
          source: (request, response) ->
            response $.ui.autocomplete.filter(appNames, extractLast(request.term))
            return
          focus: ->
            false
          select: (e, ui) ->
            terms = split(this.value)
            terms.pop()
            terms.push ui.item.value
            terms.push ''
            this.value = terms.join(",")
            false

  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit

  handleEdit: (e) ->
    e.preventDefault()
    data =
      primary_app: ReactDOM.findDOMNode(@refs.primary_app).value
      environment_tag: ReactDOM.findDOMNode(@refs.environment_tag).value
      application_tags: ReactDOM.findDOMNode(@refs.application_tags).value
    $.ajax
      method: 'PUT'
      url: "/tests/#{ @props.test.id }"
      dataType: 'JSON'
      data:
        test: data
      success: (data) =>
        @setState edit: false
        @props.handleEditRecord @props.test, data

  editTestRow: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.div
          className: "edit-test-name"
          @props.test.name
        React.DOM.div
          className: "edit-test-toggle"
          React.DOM.a
            className: 'btn btn-default btn-sm'
            onClick: @handleToggle
            'Edit'

      if "primary_app" of @props.test
        React.DOM.td null, @props.test.primary_app.name
      else
        React.DOM.td null,

      if "environment_tag" of @props.test
        React.DOM.td null, @props.test.environment_tag.name
      else
        React.DOM.td null,

      React.DOM.td null, @applicationTagsFormat()

  editTestForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.div
          className: "edit-test-name"
          @props.test.name
        React.DOM.div
          className: "edit-test-toggle"
          React.DOM.a
            className: 'btn btn-default btn-sm'
            onClick: @handleEdit
            'update'
          React.DOM.a
            className: 'btn btn-danger btn-sm'
            onClick: @handleToggle
            'cancel'
      React.DOM.td null,
        React.DOM.select
          className: 'form-control'
          defaultValue: @props.test.primary_app.name if "primary_app" of @props.test
          ref: 'primary_app'
          for app_tag in @props.applications
            React.DOM.option
              key: app_tag.id
              value: app_tag.name
              app_tag.name
      React.DOM.td null,
        React.DOM.select
          className: 'form-control'
          type: 'text'
          defaultValue: @props.test.environment_tag.name if "environment_tag" of @props.test
          ref: 'environment_tag'
          for env_tag in @props.environments
            React.DOM.option
              key: env_tag.id
              value: env_tag.name
              env_tag.name
      React.DOM.td null,
        React.DOM.div
          className: 'ui-widget'
          React.DOM.input
            className: 'form-control'
            ref: 'application_tags'
            defaultValue: @applicationTagsFormat()
            onFocus: @bindAutocomplete
            id: "tags-#{ @props.test.id }"

  render: ->
    if @state.edit
      @editTestForm()
    else
      @editTestRow()

