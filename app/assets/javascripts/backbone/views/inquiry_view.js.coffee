TestDouble.Views.Inquiries ||= {}

class TestDouble.Views.InquiryView extends TestDouble.Views.FormView
  template: JST["backbone/templates/inquiry"]

  categories: [
    "build an application",
    "receive training",
    "talk with you"
  ]

  events: ->
    _.extend {}, super,
      "submit *": "save"
      'change :input[name="category"]': "showSelectedCategory"
      'change :input': 'propogateChangesToModel'
      'click .cancel': 'cancel'

  initialize: ->
    _(@).bindAll()
    @collection.bind "add", @afterSending
    @model.bind "change:errors", () => @render()

  save: (e) ->
    @model.set fullInquiryText: @printForm(@$('form'))
    @$('.send').attr('disabled','disabled').val('contacting...')
    super e

  afterSending: =>
    @cancel()
    $alert = $(JST['backbone/templates/inquiry_alert_success'](@model.toJSON())).prependTo('body');
    $alert.alert().delay(6000).slideUp(800);

  render: ->
    $(@el).html(@template({model: @model, view: @})).fadeIn(500)
    super
    @showSelectedCategory()
    @

  showSelectedCategory: ->
    selectedClass = @$(':input[name="category"] :selected').attr('class')
    window.router.navigate('inquiry/' + selectedClass)
    @$('.category').each (i,el) -> $(el).toggleClass('hidden',!$(el).hasClass(selectedClass))

  cancel: ->
    $(@el).fadeOut(300)
    window.router.navigate '', true
