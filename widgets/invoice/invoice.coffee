class Dashing.Invoice extends Dashing.Widget
  @accessor 'value', Dashing.AnimatedValue
  @accessor 'deadline'
  @accessor 'info'

  onData: (data) ->
    if data.status
      $(@get('node')).addClass("status-#{data.status}")
