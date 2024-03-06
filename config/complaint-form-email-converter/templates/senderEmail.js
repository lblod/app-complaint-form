import * as uti from './utils';
import { formatDate } from './utils';

export function senderEmailSubject() {
  return 'Uw klacht over de werking van een lokaal bestuur.';
}

function attachmentsPlainText(attachments) {
  return attachments
    .map((a) => `${a.filename} (${uti.humanReadableSize(a.size)})`)
    .join('\n\t');
}

function attachmentsHtml(attachments) {
  return attachments
    .map((a) => `<li>${a.filename} (${uti.humanReadableSize(a.size)})</li>`)
    .join('\n\t');
}

export function senderEmailPlainTextContent(form, attachments) {
  const verzondenFrom = uti.senderName(form);
  const verzondenAt = formatDate(form.created);
  const ontvangenAt = formatDate(new Date());

  return `Geachte ${verzondenFrom}
Het Agentschap Binnenlands Bestuur Vlaanderen heeft uw klacht goed ontvangen:

Beveiligd verzonden: ${verzondenFrom}, ${verzondenAt}
Ontvangen: Agentschap Binnenlands Bestuur, ${ontvangenAt}
Naam: ${verzondenFrom}
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
ABB Vlaanderen`;
}

export function senderEmailHtmlContent(form, attachments) {
  const verzondenFrom = uti.senderName(form);
  const verzondenAt = formatDate(form.created);
  const ontvangenAt = formatDate(new Date());
  return `<p>Geachte ${verzondenFrom}</p>
<br>
<p>Het Agentschap Binnenlands Bestuur Vlaanderen heeft uw klacht goed ontvangen:</p>
<br>
<div style="margin-left: 40px;">
  <p>
    <span style="font-weight:bold;">Beveiligd verzonden:</span>
    <span>${verzondenFrom}, ${verzondenAt}</span>
  </p>
  <p>
    <span style="font-weight:bold;">Ontvangen:</span>
    <span>Agentschap Binnenlands Bestuur, ${ontvangenAt}</span>
  </p>
  <br>
  <br>
  <p>
    <span style="font-weight:bold;">Naam:</span>
    <span>${verzondenFrom}</span>
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
    <span>${form.senderEmail}</span>\
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
<br>
<p>
  Het Agentschap Binnenlands Bestuur zal u zo snel als mogelijk verdere informatie sturen over het gevolg dat aan uw klacht wordt gegeven. Meer info hierover vindt u in de rubriek “Wat doet de toezichthoudende overheid met je klacht?” in de klachtenwegwijzer (<a href="https://lokaalbestuur.vlaanderen.be/klachtenwegwijzer" target="_blank">https://lokaalbestuur.vlaanderen.be/klachtenwegwijzer</a>).
  <br>
  Info over de verwerking van uw gegevens leest u hier: <a href="https://binnenland.vlaanderen.be/privacyverklaring-abb" target="_blank">https://binnenland.vlaanderen.be/privacyverklaring-abb</a>.
</p>
<br>
<p>Hoogachtend</p>
<p>ABB Vlaanderen</p>`;
}
