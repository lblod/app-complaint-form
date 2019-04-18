import moment from 'moment';

const senderName = function(form) {
  let senderName = form.name
  if(form.contactPersonName != '-') {
    senderName = form.name;
  }
  return senderName;
};

const senderEmailSubject = function() {
  return 'Uw klacht over de werking van een lokaal bestuur.';
};

const humanReadableSize = function(size) {
  const bytes = size;
  const sizes = ['bytes', 'KB', 'MB', 'GB', 'TB'];
  if (bytes == 0) return '0 byte';
  const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
  return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
};

const attachmentsPlainText = function(attachments) {
  var attachmentsPlainText = '';
  attachments.map((attachment) => {
    const formattedAttachment = `${attachment.filename} (${humanReadableSize(attachment.size)})`;
    attachmentsPlainText += `${formattedAttachment}\n\t`;
  });
  return attachmentsPlainText;
};

const attachmentsHtml = function(attachments) {
  var attachmentsHtml = '';
  attachments.map((attachment) => {
    const formattedAttachment = `${attachment.filename} (${humanReadableSize(attachment.size)})`;
    attachmentsHtml += `<li>${formattedAttachment}</li>\n\t`;
  });
  return attachmentsHtml;
};

const senderEmailPlainTextContent = function(form, attachments) {
  return `
  Geachte ${senderName(form)}
  Het Agentschap Binnenlands Bestuur Vlaanderen heeft uw klacht goed ontvangen:

  Beveiligd verzonden: ${senderName(form)}, ${moment.tz(form.created, "Europe/Brussels").format("DD/MM/YY HH:mm")}
  Ontvangen: Agentschap Binnenlands Bestuur, ${moment().tz("Europe/Brussels").format("DD/MM/YY HH:mm")}
  Naam: ${senderName(form)}
  Contactpersoon indien vereniging: ${form.contactPersonName}
  Straat: ${form.street}
  Huisnummer: ${form.houseNumber}
  Toevoeging: ${form.addressComplement}
  Postcode: ${form.postalCode}
  Gemeente of Stad: ${form.locality}
  Telefoonnummer: ${form.telephone}
  Mailadres: ${form.senderEmail}

  Omschrijving klacht:
  ${form.content}

  Bijlagen

  ${attachmentsPlainText(attachments)}

  Het Agentschap Binnenlands Bestuur zal u zo snel als mogelijk verdere informatie sturen over het gevolg dat aan uw klacht wordt gegeven. Meer info hierover vindt u in de rubriek “Wat doet de toezichthoudende overheid met je klacht?” in de klachtenwegwijzer (https://lokaalbestuur.vlaanderen.be/klachtenwegwijzer).
  Info over de verwerking van uw gegevens leest u hier: binnenland.vlaanderen.be/privacyverklaring-abb.

  Hoogachtend
  ABB Vlaanderen
  `;
};

const senderEmailHtmlContent = function(form, attachments) {
  return `
  <p>Geachte ${senderName(form)}</p><br>
  <p>Het Agentschap Binnenlands Bestuur Vlaanderen heeft uw klacht goed ontvangen:</p><br>
  <div style="margin-left: 40px;">
    <p><span style="font-weight:bold;">Beveiligd verzonden:&nbsp;</span><span>${senderName(form)}, ${moment.tz(form.created, "Europe/Brussels").format("DD/MM/YY HH:mm")}</span></p>
    <p><span style="font-weight:bold;">Ontvangen:&nbsp;</span><span>Agentschap Binnenlands Bestuur, ${moment().tz("Europe/Brussels").format("DD/MM/YY HH:mm")}</span></p><br><br>
    <p><span style="font-weight:bold;">Naam:&nbsp;</span><span>${senderName(form)}</span></p>
    <p><span style="font-weight:bold;">Contactpersoon indien vereniging:&nbsp;</span><span>${form.contactPersonName}</span></p><br>
    <p><span style="font-weight:bold;">Straat:&nbsp;</span><span>${form.street}</span></p>
    <p><span style="font-weight:bold;">Huisnummer:&nbsp;</span><span>${form.houseNumber}</span></p>
    <p><span style="font-weight:bold;">Toevoeging:&nbsp;</span><span>${form.addressComplement}</span></p>
    <p><span style="font-weight:bold;">Postcode:&nbsp;</span><span>${form.postalCode}</span></p>
    <p><span style="font-weight:bold;">Gemeente of Stad:&nbsp;</span><span>${form.locality}</span></p><br>
    <p><span style="font-weight:bold;">Telefoonnummer:&nbsp;</span><span>${form.telephone}</span></p>
    <p><span style="font-weight:bold;">Mailadres:&nbsp;</span><span>${form.senderEmail}</span></p><br>
    <p style="font-weight:bold;">Omschrijving klacht:</p>
    <div style="margin-left: 40px;">
      ${form.content}
    </div><br>
    <p style="font-weight:bold;">Bijlagen</p>

    <ul>
      ${attachmentsHtml(attachments)}
    </ul>
  </div><br>
  <p>
    Het Agentschap Binnenlands Bestuur zal u zo snel als mogelijk verdere informatie sturen over het gevolg dat aan uw klacht wordt gegeven. Meer info hierover vindt u in de rubriek “Wat doet de toezichthoudende overheid met je klacht?” in de klachtenwegwijzer (<a href="https://lokaalbestuur.vlaanderen.be/klachtenwegwijzer" target="_blank">https://lokaalbestuur.vlaanderen.be/klachtenwegwijzer</a>).
    <br>
    Info over de verwerking van uw gegevens leest u hier: <a href="binnenland.vlaanderen.be/privacyverklaring-abb" target="_blank">binnenland.vlaanderen.be/privacyverklaring-abb</a>.
  </p>
  <p>Hoogachtend</p>
  <p>ABB Vlaanderen</p>
  `;
};

export {
  senderEmailSubject,
  senderEmailPlainTextContent,
  senderEmailHtmlContent
};
