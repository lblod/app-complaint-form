export default [
  {
    match: {
      subject: {},
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
      },
      object: {
        type: 'uri',
        value: 'http://mu.semte.ch/vocabularies/ext/ComplaintForm',
      },
    },
    callback: {
      url: 'http://complaint-form-email-converter/delta',
      method: 'POST',
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 250,
      ignoreFromSelf: true,
    },
  },
];
