/-  page, wallet=zig-wallet
/+  dbug, default-agent, server, schooner
/*  page-ui  %html  /app/page-ui/html
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 pages=(map url=@t html=@t)]
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
=|  state-0
=*  state  -
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~
    :*  %pass  /eyre/connect  %arvo  %e
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
  ?-  -.old
    %0  `this(state old)
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
      =/  json  (de-json:html q.u.body.request.inbound-request)
      =/  action  (dejs-action +.json)
      (handle-action action)
      ::
        %'GET'
      ?+    site
          :_  state
          (send [404 ~ [%plain "404 - Not Found"]])
        ::
          [%apps %page ~]
        ?.  authenticated.inbound-request
          :_  state
          %-  send
          [302 ~ [%login-redirect './apps/page']]
        :_  state
        (send [200 ~ [%html page-ui]])
          ::
          [%apps %page %state ~]
        ?.  authenticated.inbound-request
          :_  state
          %-  send
          [302 ~ [%login-redirect './apps/page']]
        :_  state
        (send [200 ~ [%json (enjs-state +.state)]])
          ::
          [%apps %page @tas ~]
        :_  state
        (send [200 ~ [%html (~(got by pages) `@t`+>-.site)]])
      ==
    ==
  ::
  ++  enjs-state
    =,  enjs:format
    |=  state=(map @t @t)
    ^-  json
    :-  %a
    %+  turn
      %~  tap  by  state
    |=  pare=[@t @t]
    :-  %a
    :~  [%s -.pare]
        [%s +.pare]
    ==
  ::
  ++  dejs-action
    =,  dejs:format
    |=  jon=json
    ^-  action:^page
    %.  jon
    %-  of
    :~  [%new-page (at ~[so so])]
        [%delete-page so]
        [%tip (se %ud)]
    ==
  ::
  ++  handle-action
    |=  =action:page
    ^-  (quip card _state)
    ?>  =(src.bowl our.bowl)
    ?-    -.action
        %new-page
      ?>  ?!  =(url:action 'state')
      `state(pages (~(put by pages) url:action html:action))
    ::
        %delete-page
      `state(pages (~(del by pages) url:action))
    ::
        %tip
      ::  produce tip transaction and send to uqbar %wallet
      =/  user-address=@ux
        =-  ?>  ?=(%addresses -.-)
            (head ~(tap in saved.-))
        .^  wallet-update:wallet  %gx
            /(scot %p our.bowl)/wallet/(scot %da now.bowl)/addresses/noun
        ==
      =/  zigs-account-id=@ux
        %:  hash-data:smart:wallet
            0x74.6361.7274.6e6f.632d.7367.697a
            user-address
            0x0
            `@`'zigs'
        ==
      ::
      :_  state  :_  ~
      :*  %pass  /tip-poke
          %agent  [our.bowl %uqbar]
          %poke  %wallet-poke
          !>  ^-  wallet-poke:wallet
          :*  %transaction
              ~
              from=user-address
              contract=0x74.6361.7274.6e6f.632d.7367.697a
              town=0x0
              :^    %give
                  to=page-tip-address:page
                amount.action
              item=zigs-account-id
          ==
      ==
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
