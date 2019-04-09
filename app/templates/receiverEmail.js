import moment from 'moment';

const fileDownloadPrefix = process.env.FILE_DOWNLOAD_PREFIX || 'localhost';

const senderName = function(form) {
  let senderName = form.name
  if(form.contactPersonName != '-') {
    senderName = form.name;
  }
  return senderName;
};

const receiverEmailSubject = function(form) {
  return `Klacht van ${senderName(form)} over de werking van een lokaal bestuur`;
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
    const downloadLink = `${fileDownloadPrefix}/files/${attachment.uuid}/download?name=${attachment.filename}`;
    const formattedAttachment = `${attachment.filename} (${humanReadableSize(attachment.size)})`;
    attachmentsPlainText += `${formattedAttachment} (${downloadLink})\n\t`;
  });
  return attachmentsPlainText;
};

const attachmentsHtml = function(attachments) {
  var attachmentsHtml = '';
  attachments.map((attachment) => {
    const downloadLink = `${fileDownloadPrefix}/files/${attachment.uuid}/download?name=${attachment.filename}`;
    const formattedAttachment = `${attachment.filename} (${humanReadableSize(attachment.size)})`;
    attachmentsHtml += `<li><a href="${downloadLink}" target="_blank">${formattedAttachment}</a></li>\n\t`;
  });
  return attachmentsHtml;
};

const receiverEmailPlainTextContent = function(form, attachments) {
  return `
    Geachte
    Er werd een klacht ingediend bij het Agentschap Binnenlands Bestuur via het Digitaal Klachtenformulier. Hieronder vindt u de inhoud van de klacht en de gegevens van klager

      Beveiligd verzonden: ${senderName(form)}, ${moment.tz(form.created, "Europe/Brussels").format("DD/MM/YY HH:mm")}
      Ontvangen: Agentschap Binnenlands Bestuur, ${moment().tz("Europe/Brussels").format("DD/MM/YY HH:mm")}
      Naam: ${form.name}
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

    De afzender heeft een bevestigingsmail gekregen, waarin vermeld staat dat ABB binnen een termijn van 10 werkdagen zal antwoorden.
    Hoogachtend
    ABB Vlaanderen
    `;
};

const receiverEmailHtmlContent = function(form, attachments) {
  return `
    <p>Geachte</p><br>
    <p>Er werd een klacht ingediend bij het Agentschap Binnenlands Bestuur via het Digitaal Klachtenformulier. Hieronder vindt u de inhoud van de klacht en de gegevens van klager</p><br>
    <div style="margin-left: 40px;">
      <p><span style="font-weight:bold;">Beveiligd verzonden:&nbsp;</span><span>${senderName(form)}, ${moment.tz(form.created, "Europe/Brussels").format("DD/MM/YY HH:mm")}</span></p>
      <p><span style="font-weight:bold;">Ontvangen:&nbsp;</span><span>Agentschap Binnenlands Bestuur, ${moment().tz("Europe/Brussels").format("DD/MM/YY HH:mm")}</span></p><br><br>
      <p><span style="font-weight:bold;">Naam:&nbsp;</span><span>${form.name}</span></p>
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
    <p>De afzender heeft een bevestigingsmail gekregen, waarin vermeld staat dat ABB binnen een termijn van 10 werkdagen zal antwoorden.</p><br>
    <p>Hoogachtend</p>
    <p>ABB Vlaanderen</p>
    `;
};

export {
  receiverEmailSubject,
  receiverEmailPlainTextContent,
  receiverEmailHtmlContent
};
