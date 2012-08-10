#= require jquery
#= require jquery_ujs

jQuery.fn.st_carouselWithThumbs = (options) ->
  defaults =
    slideshow: true
    speed: 6000

  opts = jQuery.extend(defaults, options)

  this.each -> 
    $elmt = jQuery this
    $citem = $elmt.children()
    $elmt.append '<div class="st_oc"><div class="st_cc"></div></div><div class="st_thumbs"></div>'
    $citem.appendTo('.st_cc')
    $st_cc = $elmt.find('.st_cc')
    $st_oc = $elmt.find('.st_oc')
    $size = $citem.size()
    
    
    
    $elmt.css position: 'relative'
    
    $st_oc.css 
      height: $elmt.height(), 
      width: $elmt.width(), 
      overflow: 'hidden', 
      position: 'relative'
    
    $st_cc.css
      height: $elmt.height(),
      width: $elmt.width() * $size,
      overflow: 'hidden',
      position: 'absolute'
    
    $citem.css
      position: 'relative',
      height: $elmt.height(),
      width: $elmt.width(),
      float: 'left',
      overflow: 'hidden'
    
    $citem
      .find('.carousel_item_description')
      .css
        position: 'absolute',
        height: $elmt.height(),
        width: $elmt.width(),
        top: '0px',
        left: '0px',
        overflow: 'hidden'
    
    
    # Setting up previous n next control
    $cidx = 0
    $prev = $elmt.find('.st_prev')
    $next = $elmt.find('.st_next')
    
    $prev
      .css
        float: 'left'
      .click -> 
        $cidx = if ($cidx == 0) then $size - 1 else $cidx - 1
        $st_cc.animate
          left: $cidx * -$elmt.width()
        return
    
    $next
      .css
        float: 'right'
      .click ->
        nextPage()
        return
    
    $next_interval = setInterval( "nextPage()", opts.speed )
    window.nextPage = -> 
      $cidx = if ($cidx == $size - 1) then 0 else $cidx + 1
      goTo($cidx)
      return
    
    window.goTo = ($gt_idx) ->
      $cidx = $gt_idx
      $st_cc.animate
        left: $cidx * -$elmt.width()
      $st_thumbs.find('.st_thumbs_item').removeClass('selected').parent().find('.st_thumbs_item').eq($cidx).addClass('selected')
      return


    $elmt.hover(
      -> (
        clearInterval($next_interval)
        return
      ),
      -> (
        $next_interval = setInterval("nextPage()", opts.speed)
        return
      )
    )

    
    $st_thumbs = $elmt.find('.st_thumbs')

    $st_oc.find('.carousel_item').each ->
      $st_thumbs.append('<div class="st_thumbs_item"></div>')
      return

    $st_thumbs.find('.st_thumbs_item')
      .click -> 
        goTo(jQuery(this).index())
        return
      .eq(0)
      .addClass('selected')

    
    return
    
$ -> (
  $('#featured_component .component_content')
    .st_carouselWithThumbs
      speed: 10000
  return
)
