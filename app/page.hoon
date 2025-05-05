/-  *page
/+  dbug, default-agent, server, schooner
/*  page-ui  %html  /app/page-ui/html
|%
+$  versioned-state
  $%  state-0
      state-1
  ==
+$  state-0  [%0 pages=(map url=@t html=@t)]
+$  state-1  [%1 pages=(map url=@t [tag=@tas data=@])]
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
=|  state-1
=*  state  -
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~  :*  %pass  /eyre/connect  %arvo  %e
          %connect  `/apps/page  %page
      ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-    -.old
      %1  `this(state old)
  ::
      %0
    :-  ~
    %=  this
      state
      :-  %1
      %-  malt
      %+  turn
        ~(tap by pages.old)
      |=  [url=@t html=@t]
      [url [%html `@`html]]
    ==
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  (on-poke:def mark vase)
      %handle-http-request
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  (quip card _state)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    =+  send=(cury response:schooner eyre-id)
    ::
    ?+    method.request.inbound-request
      [(send [405 ~ [%stock ~]]) state]
      ::
        %'POST'
      ?.  authenticated.inbound-request
        :_  state
        %-  send
        [302 ~ [%login-redirect './apps/page']]
      ?~  body.request.inbound-request
        [(send [405 ~ [%stock ~]]) state]
      =/  json  (de:json:html q.u.body.request.inbound-request)
      =/  action  (dejs-action +.json)
      =^  cards  state
        (handle-action action)
      :_  state
      (send [200 ~ [%none ~]])
      ::
        %'GET'
      :_  state
      ?+    site
          (send [404 ~ [%plain "404 - Not Found"]])
      ::
          [%apps %page ~]
        ?.  authenticated.inbound-request
          (send [302 ~ [%login-redirect './apps/page']])
        (send [200 ~ [%html page-ui]])
        ::
          [%apps %page %state ~]
        ?.  authenticated.inbound-request
          (send [302 ~ [%login-redirect './apps/page']])
        (send [200 ~ [%json enjs-state]])
        ::
          [%apps %page @tas ~]
        =/  c  (~(got by pages) `@t`+>-.site)
        =/  resource  ;;(resource:schooner [tag.c data.c])
        (send [200 ~ resource])
      ==
    ==
  ::
  ++  enjs-state
    =,  enjs:format
    ^-  json
    :-  %a
    %+  turn
      %~  tap  by  pages
    |=  [url=@t tag=@tas data=@]
    %-  pairs
    :~  [%url [%s url]]
        [%tag [%s tag]]
    ==
  ::
  ++  dejs-action
    =,  dejs:format
    |=  jon=json
    ^-  action
    %.  jon
    %-  of
    :~  [%new-page (ot ~[url+so tag+so data+so])]
        [%delete-page so]
    ==
  ::
  ++  handle-action
    |=  act=action
    ^-  (quip card _state)
    ?>  =(src.bowl our.bowl)
    ?-    -.act
        %new-page
      ?>  ?!  =(url.act 'state')
      =/  data
        ?:  =(%html tag.act)
          data.act
        q:(need (de:base64:mimes:html data.act))
      `state(pages (~(put by pages) url.act tag.act data))
    ::
        %delete-page
      `state(pages (~(del by pages) url.act))
    ==
  --
++  on-peek  on-peek:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--
