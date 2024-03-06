import envvar from 'env-var';
import * as uti from './utils';
import { formatDate } from './utils';

const fileDownloadPrefix = envvar
  .get('FILE_DOWNLOAD_PREFIX')
  .required()
  .example('http://localhost/')
  .asUrlString();

export function receiverEmailSubject(form) {
  return `Klacht van ${uti.senderName(
    form,
  )} over de werking van een lokaal bestuur`;
}

function attachmentsPlainText(attachments) {
  return attachments
    .map((a) => {
      const downloadLink = `${fileDownloadPrefix}files/${a.uuid}/download?name=${a.filename}`;
      const size = uti.humanReadableSize(a.size);
      return `${a.filename} (${size}) (${downloadLink})`;
    })
    .join('\n\t');
}

function attachmentsHtml(attachments) {
  return attachments
    .map((a) => {
      const downloadLink = `${fileDownloadPrefix}files/${a.uuid}/download?name=${a.filename}`;
      const size = uti.humanReadableSize(a.size);
      const formattedAttachment = `${a.filename} (${size})`;
      return `<li><a href="${downloadLink}" target="_blank">${formattedAttachment}</a></li>`;
    })
    .join('\n\t');
}

export function receiverEmailPlainTextContent(form, attachments) {
  const verzondenFrom = uti.senderName(form);
  const verzondenAt = formatDate(form.created);
  const ontvangenAt = formatDate(new Date());
  return `Geachte
Er werd een klacht ingediend bij het Agentschap Binnenlands Bestuur via het Digitaal Klachtenformulier. Hieronder vindt u de inhoud van de klacht en de gegevens van klager

  Beveiligd verzonden: ${verzondenFrom}, ${verzondenAt}
  Ontvangen: Agentschap Binnenlands Bestuur, ${ontvangenAt}
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

De afzender heeft een mail gekregen waarin werd aangegeven dat zijn klacht succesvol werd ingediend en hij nog verder geïnformeerd zal worden over het gevolg dat aan de klacht wordt gegeven.
Hoogachtend
ABB Vlaanderen`;
}

export function receiverEmailHtmlContent(form, attachments) {
  const verzondenFrom = uti.senderName(form);
  const verzondenAt = formatDate(form.created);
  const ontvangenAt = formatDate(new Date());
  return `<p>Geachte</p>
<br>
<p>Er werd een klacht ingediend bij het Agentschap Binnenlands Bestuur via het Digitaal Klachtenformulier. Hieronder vindt u de inhoud van de klacht en de gegevens van klager</p>
<div style="margin-left: 40px;">
  <p>
    <span style="font-weight:bold;">Beveiligd verzonden:</span>
    <span>${verzondenFrom}, ${verzondenAt}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Ontvangen:</span>
    <span>Agentschap Binnenlands Bestuur, ${ontvangenAt}</span>
  </p>
  <br><br>
  <p>
    <span style="font-weight:bold;">Naam:</span>
    <span>${form.name}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Contactpersoon indien vereniging:</span>
    <span>${form.contactPersonName}</span>
  </p>
  <br>
  <p>
    <span style="font-weight:bold;">Straat:</span>
    <span>${form.street}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Huisnummer:</span>
    <span>${form.houseNumber}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Toevoeging:</span>
    <span>${form.addressComplement}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Postcode:</span>
    <span>${form.postalCode}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Gemeente of Stad:</span>
    <span>${form.locality}</span>
  </p>
  <br>
  <p>
    <span style="font-weight:bold;">Telefoonnummer:</span>
    <span>${form.telephone}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Mailadres:</span>
    <span>${form.senderEmail}</span>
  </p>
  <br>
  <p style="font-weight:bold;">Omschrijving klacht:</p>
  <div style="margin-left: 40px;">
    ${form.content.replace(/\n/g, '<br />')}
  </div>
  <br>
  <p style="font-weight:bold;">Bijlagen</p>
  <ul>
    ${attachmentsHtml(attachments)}
  </ul>
</div>
<p>
  De afzender heeft een mail gekregen waarin werd aangegeven dat zijn klacht succesvol werd ingediend en hij nog verder geïnformeerd zal worden over het gevolg dat aan de klacht wordt gegeven.
</p>
<br>
<p>Hoogachtend</p>
<p>ABB Vlaanderen</p>`;
}
