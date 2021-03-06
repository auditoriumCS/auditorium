(function() {
  
    var classRoom = {
    
    /**
     *  NameSpaces
     */
    //BOSH: "http://localhost/http-bind",
    //BOSH: "/http-bind",
    BOSH: "http://141.76.41.204:7070/http-bind/",
    MUC: "http://jabber.org/protocol/muc",
    OPENFIREDOMAIN: "141.76.41.204",
    //ROOM: "test@conference.kp",
    ROOM: null,
    SLIDE: "acms:ns:slide",
    INTERRUPTION: "amcs:ns:interruption",
    
     /**
     *  Globals
     */
    connection: null,
    nickName: null,
    joined: null, // onConnected->false; roomJoined->true
    participants: null, //Boolean Array: true - joined the room
    jid: null,
    user: null,
    pw: null,
    role: null,
    
    /**
     *  functions
     */
    connect: function(data) {
    // Reset before every connection attempt to make sure reconnections work after authfail, ...
    //            if (classRoom.connection !== null)
    //                classRoom.connection.reset();

      var authFail = false;

      classRoom.connection.connect(data.jid, data.password,
      function(status) {
          if (status === Strophe.Status.CONNECTED) {
              classRoom.connected();
              console.log('Connected');
          } else if (status === Strophe.Status.DISCONNECTED) {
              if (authFail) {
                  classRoom.register();
                  console.log('Failed to authorize DISCONNECTED');
              } else
                  classRoom.disconnected();
                  console.log('Disconnected');
          } else if (status === Strophe.Status.AUTHFAIL) {
              classRoom.connection.disconnect();
              authFail = true;
              console.log('Faild to authorize AUTHFAIL')
          }
      });
    },

  connected: function() {
    classRoom.joined = false;
    classRoom.participants = {};
    classRoom.Action.PresencePriority('-1');
    classRoom.Utils.registerHandlers();
    classRoom.Action.Presence(classRoom.nickName);


    jQuery('#create_room').hide();
    jQuery('#connect_room').hide();
    jQuery('#page').show();
    console.log('Call CONNECTED');
  },
    
  disconnected: function() {
    classRoom.connection = null;


    jQuery('#memberList').empty();
    jQuery('#chatContainer').empty();
    jQuery('#avatar').empty();
    jQuery('#page').hide();
    jQuery('#create_room').show();
    jQuery('#connect_room').show();
    console.log('Call DISCONNECTED');

  },
      
  register: function() {
    var callback = function(status) {
      console.log("status: " + status);
      if (status === Strophe.Status.REGISTER) {
          classRoom.connection.register.fields.username = classRoom.user;
          classRoom.connection.register.fields.password = classRoom.pw;
          classRoom.connection.register.submit();
      } else if (status === Strophe.Status.REGISTERED) {
          console.log("registered!");
          //classRoom.connection.register.authenticate();
          classRoom.connection.disconnect();
      } else if (status === Strophe.Status.CONNECTED) {
          console.log("logged in!");
      } else if (status === Strophe.Status.DISCONNECTED) {

          //jQuery(document).trigger('connect');

          classRoom.connect({jid: classRoom.jid, password: classRoom.pw});
      } else {
          console.log("status: " + status);
      }
    };
    classRoom.connection.register.connect(classRoom.jid, callback);
    console.log('Call REGISTER');
  },
    
   /**
       *  object
       *
       *
       *
       */
  FeedBack: {
    actualSlide: 1,
    slideCount: 4,
    
    handleSlideChange: function() {
      var count = classRoom.FeedBack.slideCount;
        var actualSlide = classRoom.FeedBack.actualSlide.toString();
        var time = classRoom.Utils.time();


        jQuery('#slideStatus').text(actualSlide + ' / ' + count);
        classRoom.FeedBack.enableItems();

        classRoom.Action.SlideChange(actualSlide, time);
        console.log('Call HANDLE SLIDE CHANGE');
      },

    setSlideStatus: function() {
      var count = classRoom.FeedBack.slideCount;

      jQuery('#slideStatus').text(classRoom.FeedBack.actualSlide + ' / ' + count);
      console.log('Call SET SLIDE STATUS');
    },
  },
     /**
         *  object with helper functions
         *
         *
         *
         */
        Utils: {
            /**
             *  function: adding new lines at the bottom and fix scrollbar position
             */
            addMessage: function(message) {

                var chatContainer = jQuery('#chatContainer').get(0);
                var bool_bottom = chatContainer.scrollTop >= chatContainer.scrollHeight - chatContainer.clientHeight;

                jQuery('#chatContainer').append(message);

                if (bool_bottom) {
                    chatContainer.scrollTop = chatContainer.scrollHeight;
                }

                console.log('Call ADD MESSAGE');
            },
      
      /**
             *  function: returns time
             */
            time: function() {
                date = new Date();

                hour = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours());
                minute = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes());
                second = (date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds());

                return  hour + ':' + minute + ':' + second;
                console.log('Call TIME');
            },
      
            /** Function: addHandler
             * Wrapper for Strophe.Connection.addHandler() to add a stanza handler for the connection.
             *
             * Parameters:
             *   (Function) handler - The user callback.
             *   (String) ns - The namespace to match.
             *   (String) name - The stanza name to match.
             *   (String) type - The stanza type attribute to match.
             *   (String) id - The stanza id attribute to match.
             *   (String) from - The stanza from attribute to match.
             *   (String) options - The handler options
             *
             * Returns:
             *   A reference to the handler that can be used to remove it.
             */
            addHandler: function(handler, ns, name, type, id, from, options) {
                return classRoom.connection.addHandler(handler, ns, name, type, id, from, options);
                console.log('Call ADD HANDLER');
            },
      
      registerHandlers: function() {
                classRoom.Utils.addHandler(classRoom.Handler.onPresence, null, 'presence');
                classRoom.Utils.addHandler(classRoom.Handler.onPublicMessage, null, 'message', 'groupchat');
                classRoom.Utils.addHandler(classRoom.Handler.onPrivateMessage, null, 'message', 'chat');
                classRoom.Utils.addHandler(classRoom.Handler.onSlideChange, classRoom.SLIDE, 'message', 'groupchat');
                classRoom.Utils.addHandler(classRoom.Handler.configRoom, Strophe.NS.Client, 'message', 'groupchat', '', classRoom.ROOM);
        classRoom.Utils.addHandler(classRoom.Handler.onInterruption, classRoom.INTERRUPTION, 'message', 'groupchat');
        console.log('Call REGISTER HANDLERS');
      }
        },
    
    /**
         *  object containing all stanzas being sent to the jabber host
         *
         *
         *
         */
        Action: {
            PresencePriority: function(index) {
                classRoom.connection.send($pres().c('priority').t(index));
            },
      
            Presence: function(name) {
                classRoom.connection.send($pres({to: classRoom.ROOM + '/'
                            + name}).c('x', {xmlns: classRoom.MUC}))
            },
      
            Disconnect: function(name) {
                classRoom.connection.send($pres({to: classRoom.ROOM + '/' + name,
                    type: "unavailable"
                }));
            },
      
            PublicMessage: function(text, time) {
                classRoom.connection.send($msg({to: classRoom.ROOM, type: 'groupchat'})
                        .c('body').t(text)
                        .up()
                        .c('time', time));
            },
      
            PrivateMessage: function(text, time, nick) {
                classRoom.connection.send($msg({to: classRoom.ROOM + '/' + nick, type: 'chat'})
                        .c('body').t(text)
                        .up()
                        .c('time', time));
            },
      
            SlideChange: function(actualSlide, time) {
                classRoom.connection.send($msg({to: classRoom.ROOM, type: 'groupchat'})
                        .c('body').t('AKTUELLER SLIDE: ' + actualSlide)
                        .up()
                        .c('time', time)
                        .up()
                        .c('feedback', {xmlns: classRoom.SLIDE})
                        .c('slide', actualSlide));
            },

            sendConfig: function(msg) {
                console.log("sendConfig");

                var msg = jQuery(msg);
                var fields = msg.find('field');
                classRoom.connection.muc.saveConfiguration(classRoom.ROOM, fields);
            },
      
      interruption: function(type) {
        var kind;
        var text = type.toString()
        
        if (type) kind = "Chat is paused.";
        else if(!type) kind = "Chat is resumed.";
        
        classRoom.connection.send($msg({to: classRoom.ROOM, type: 'groupchat'})
            .c('body').t(kind)
                        .up()
                        .c('interruption', {xmlns: classRoom.INTERRUPTION})
                        .c('type', text));
      }
        },
    
     /**
         *  object containing all handlers reacting on Strophe
         *
         *
         *
         */
        Handler: {
            /**
             *  function: populate member area, nickname conflict, handle own presence, set joined
             */
            onPresence: function(presence) {

                var from = jQuery(presence).attr('from');
                var nick = Strophe.getResourceFromJid(from);
        
                /*if theres no error, user is available and user has not joined the room yet set add
                 the user to participants*/

                if (jQuery(presence).attr('type') === 'error' && !classRoom.joined) {

                    classRoom.connection.disconnect();
                    alert('Dem Raum konnte nicht beigetreten werden');
                }
                else

                if (!classRoom.participants[nick] && jQuery(presence).attr('type') !== 'unavailable') {
                    classRoom.participants[nick] = true;
                    /*now that the user has joined watch up for adding to list or to avatar and handle pause Stuff*/
                    if (nick === classRoom.nickName) {
                        jQuery('#avatar').text(nick);
            
            if (jQuery(presence).find('x[xmlns="http://jabber.org/protocol/muc#user"]').length > 0) {
              jQuery(presence).find('x > item').each(function() {
                
                if( jQuery(this).attr('role') === 'moderator') {
                  classRoom.role = 'moderator';
                  classRoom.View.activateStop();
                }else if( jQuery(this).attr('role') === 'participant') classRoom.role = 'participant';

                    else classRoom.role ='none';
              });
            } 
                    }
                    else {

                        jQuery('#memberList').append("<li id='" + nick + "'>" + "<div class='member'>"

                                + "<div class='image'><img src='../assets/member.png' alt='pic'></div>"
                                + "<div class='nick'>" + nick + "</div></li>");
                    }
                }
                else
                /*user leaves the room, remove him from list*/

                if (classRoom.participants[nick] && jQuery(presence).attr('type') === 'unavailable') {
                    jQuery('#memberList li').each(function() {
                        if (nick === jQuery(this).attr('id')) {
                            jQuery(this).remove();

                            return false;
                        }
                    });
                }

                /*handle own presence, nick changed?*/

                if (jQuery(presence).attr('type') !== 'error' && !classRoom.joined) {

                    if (jQuery(presence).find("status[code ='110']").length > 0) {

                        if (jQuery(presence).find("status[code ='210']").length > 0) {

                            classRoom.nickName = Strophe.getResourceFromJid(from);
                        }
                    }
                    else {
                        classRoom.joined = true;
                        classRoom.FeedBack.setSlideStatus();
                    }
                }

                return true;
            },
      
            /**
             *  function: populate chat messages and also feedback messages (hidden)
             */
            onPublicMessage: function(message) {

                var from = jQuery(message).attr('from')

                var nick = Strophe.getResourceFromJid(from);

                if (nick === null)
                    nick = "Server";


                var text = jQuery(message).children('body').text();
                var time = jQuery(message).children('time').text();

                if (jQuery(message).find('feedback').length > 0 || jQuery(message).find('interruption').length > 0) {

                    classRoom.Utils.addMessage("<div class='message hidden'>"
                            + "<div class='head'>" + time + " | " + nick + ":" + "</div>"
                            + "<div class='body'>" + text + "</div></div>");
                    return true;
                }
                else

                if (jQuery(message).find('body').length > 0) {
                    classRoom.Utils.addMessage("<div class='message'>"
                            + "<div class='head'>" + time + " | " + nick + ":" + "</div>"
                            + "<div class='body'>" + text + "</div></div>");
                }
                return true;
            },
      
            /**
             *  function: populate private chat messages
             */
            onPrivateMessage: function(message) {

                var from = jQuery(message).attr('from')
                var nick = Strophe.getResourceFromJid(from);

                var text = jQuery(message).children('body').text();
                var time = jQuery(message).children('time').text();


                classRoom.Utils.addMessage("<div class='message private'>" +
                        "<div class='head'>" + time + " | " + nick + ":" + "</div>" +
                        "<div class='body'>" + text + "</div></div>");
                return true;
            },
      
       /**
             *  function: sets actualSlide, updates View, enables FeedBackItems
             */
            onSlideChange: function(message) {
                var sSlide;


                if (jQuery(message).find('feedback').length > 0) {
                    jQuery(message).find('feedback > slide').each(function() {
                        sSlide = jQuery(this).text();

                    });
                }

                var actualSlide = +sSlide;
                classRoom.FeedBack.actualSlide = actualSlide;

        classRoom.FeedBack.setSlideStatus();
                return true;
            },
            
            configRoom: function() {
                console.log("handler configRoom works");
                classRoom.connection.muc.configure(classRoom.ROOM, classRoom.Action.sendConfig);
            },
      
      onInterruption: function(message) {

        if (jQuery(message).find('interruption').length > 0) {
                    jQuery(message).find('interruption > type').each(function() {
              kind = jQuery(this).text();
              
              if( kind === "true") {
                console.log('pause');
                classRoom.View.onStop();
              }
              else if(kind === "false") {
                console.log('resumed');
                classRoom.View.onGo();  
              }
                    });
        }
        return true;
      }
    },
    
     View: {
            showLoginBox: function(style) {

                jQuery("#loginDialog").show();
                
                if (style === "connect") {
                    console.log("showLoginBox connect");
                    jQuery("#login_user").hide();
                    jQuery("#login_pw").hide();
                } else if (style === "create") {
                    jQuery("#login_user").show();
                    jQuery("#login_pw").show();
                    console.log("showLoginBox create");
                } else {
                    console.log("showLoginBox else");
                    jQuery(".ui-dialog-titlebar-close").hide();
                    jQuery(".ui-dialog-titlebar").css({'background': '#3B5998', border: '0'});
                }
                jQuery('#loginDialog').dialog({
                    autoOpen: true,
                    draggable: false,
                    modal: true,
                    resizable: false,
                    open: function() {

//                        jQuery(".ui-dialog-titlebar-close").hide();
              jQuery(".ui-dialog-titlebar").css({'background': '#3B5998', border: '0'});

                    },
                    title: 'LOGIN',
                    buttons: {
                        'Enter': function()
                        {

                            classRoom.nickName = jQuery('#nickname').val();
                            if (style === "create") {
                                classRoom.jid = jQuery('#jid').val() + "@" + classRoom.OPENFIREDOMAIN;
                                classRoom.pw = jQuery('#password').val();
                                classRoom.connection = new Strophe.Connection(classRoom.BOSH);
                                classRoom.connect({jid: classRoom.jid, password: classRoom.pw});

                            } else if (style === "connect") {
                                // $.ajax({
                                //     url: 'userinformation.json',
                                //     dataType: 'json',
                                //     async: false,
                                //     //data: myData,
                                //     success: function(data) {
                                //         classRoom.user = data.user;
                                //         classRoom.pw = data.pw;
                                //         classRoom.jid = data.user + "@" + classRoom.OPENFIREDOMAIN;
                                //     }
                                // });
                                classRoom.connection = new Strophe.Connection(classRoom.BOSH);
                                classRoom.connect({jid: "student", password: "student"});
                                console.log('Call CONNECT with STROPHE');
                            }
                            var roomName = $('#room').val();
                            var eventid = null;
                            eventid = (window.location.pathname.split("/")).pop();
                            var roomName = "room_" + eventid;
                            classRoom.ROOM = roomName + "@conference." + classRoom.OPENFIREDOMAIN
                            // classRoom.connection = new Strophe.Connection(classRoom.BOSH);
                            // classRoom.connect({jid: classRoom.jid, password: classRoom.pw});

                            jQuery('#password').val('');
                            jQuery(this).dialog('close');
                        }
                    },
          
                    focus: function() {

                        jQuery(':input', this).keyup(function(event) {
                            if (event.keyCode == 13) {
                                jQuery('.ui-dialog-buttonpane button:first').click();
                            }
                        });
                    }
                });

                jQuery(".ui-dialog-titlebar-close").text('X');
            },
      
      onStop: function() {
        jQuery('#page').hide();
        jQuery('body').css(
        { 'background-image': 'url(../assets/amcs_logo.png)',
          'background-size':'50%',
          'background-repeat':'no-repeat',
          'background-position': 'center' 
        });
        classRoom.View.activateGo();
      },
      
      onGo: function() {

        jQuery('#page').show();
        //jQuery('#activate').remove();
        jQuery('body').find('#activate').each(function() { jQuery(this).remove(); });
        jQuery('body').removeAttr('style');

      },
      
      activateStop: function() {
        if(classRoom.role === 'moderator') 

          jQuery('#stop').removeClass("hidden");
      },
      
      activateGo : function() {
        if(classRoom.role === 'moderator') {

          jQuery('body').find('#activate').each(function() { jQuery(this).remove(); });
          jQuery('body').append('<div id ="activate" style="margin: 0 auto; text-align:right;">'

          +'<img style="width:40px;height:40px;" id="go" src="../assets/go.png" alt="Enable Chat" title="Enable Chat"></div>');
        }
      }
        },
  };
  
   /**
     *
     *
     *jQuery ready >>>>> TODO: remove
     *
     *
     *
     */

  jQuery(document).ready(function() {
    jQuery('#page').hide();
        classRoom.ROOM = document.title.toLowerCase() + "@conference." + classRoom.OPENFIREDOMAIN; //?????
        classRoom.ROOM = "test" + "@conference." + classRoom.OPENFIREDOMAIN; //??????
    });
  
   /**
     *
     *
     *jQuery Event Handlers
     *
     *
     *
     */
   

   jQuery(document).on('click', '#disconnect', function() {
        classRoom.Action.Disconnect(classRoom.nickName);
        classRoom.connection.disconnect();
    });
  

  jQuery(document).on('keypress', '#input', function(e) {
        if (e.which === 13) {
            e.preventDefault();
            var text = jQuery(this).val();
            var time = classRoom.Utils.time();
            classRoom.Action.PublicMessage(text, time);
            jQuery(this).val('');
        }
    });
  
  jQuery(document).on('click', 'ul#memberList li div.member', function(e) {
    e.preventDefault();
    var nick = jQuery(this).parent().attr('id');

    jQuery('#pmDialog').dialog({
      autoOpen: true,
      draggable: true,
      modal: false,
      resizable: true,
      title: 'PM to: ' + nick,
      open: function() {

        jQuery(".ui-dialog-titlebar").css({'background': '#3B5998', border: '0'});
      },
      buttons: {
        'SEND': function() {
          var text = jQuery('#pmMessage').val();
          var time = classRoom.Utils.time();
          classRoom.Action.PrivateMessage(text, time, nick);
          jQuery('#pmMessage').val('');
          jQuery(this).dialog('close');
        }
      }
    });
  });
   

  jQuery(document).on('click', '#create_room', function() {
        classRoom.View.showLoginBox("create");
    });
  
    jQuery(document).on('click', '#connect_room', function() {
        classRoom.View.showLoginBox("connect");
    });
  
  jQuery(document).on('click', '#stop', function() {
    classRoom.Action.interruption(true);
    });
  
  jQuery(document).on('click', '#go', function() {
    classRoom.Action.interruption(false);
    });
  
}()); 
    