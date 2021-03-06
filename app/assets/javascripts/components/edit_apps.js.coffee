@EditApps = React.createClass
  getInitialState: ->
    applications: @props.data
    delete_modal: false

  getDefaultProps: ->
    applications: []

  showDeleteModal: (app) ->
    @setState modal_app: app
    @setState delete_modal: true

  closeDeleteModal: ->
    @setState delete_modal: false

  addApp: (app) ->
    apps = @state.applications.slice()
    apps.push(app)
    @setState applications: apps

  deleteApp: (app) ->
    apps = @state.applications.slice()
    index = apps.indexOf app
    apps.splice index, 1
    @replaceState applications: apps

  updateApp: (app, data) ->
    index = @state.applications.indexOf app
    apps = React.addons.update(@state.applications, { $splice: [[index, 1, data]] })
    @replaceState applications: apps

  componentDidMount: ->
    tableOffset = $("#edit-apps-table").offset().top
    header = $("#edit-apps-table > thead")
    fixedHeader = $("#header-fixed").append(header.clone())
    fixedHeader.width(header.width())

    $(window).scroll( ->
      offset = $(this).scrollTop()

      if (offset >= tableOffset and fixedHeader.is(":hidden"))
        fixedHeader.show()
      else if (offset < tableOffset)
        fixedHeader.hide()
    )

  render: ->
    React.DOM.div { id: 'edit-applications' },
      React.createElement AppForm, handleNewApp: @addApp
      React.DOM.table { className: 'table table-bordered', id: 'edit-apps-table' },
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Application'
            React.DOM.th null, 'Group'
            React.DOM.th null, 'Threshold'
            React.DOM.th null, ''
        React.DOM.tbody { id: "app-table-body" },
          for app in @state.applications
            React.createElement EditApp, key: app.id, app: app, handleDeleteApp: @deleteApp, handleEditApp: @updateApp, handleDeleteModal: @showDeleteModal
      React.DOM.table { id: "header-fixed", className: "table table-bordered" }
      if @state.delete_modal
        React.createElement DeleteModal, app: @state.modal_app, handleClose: @closeDeleteModal, handleDeleteApp: @deleteApp

