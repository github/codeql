import javascript

from EmailSender send
select send, send.getFrom(), send.getTo(), send.getSubject(), send.getPlainTextBody(),
  send.getHtmlBody()
