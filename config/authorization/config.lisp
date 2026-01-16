;;;;;;;;;;;;;;;;;;;
;;; delta messenger
(in-package :delta-messenger)

(add-delta-logger)
(add-delta-messenger "http://deltanotifier/")

;;;;;;;;;;;;;;;;;
;;; configuration
(in-package :client)
(setf *log-sparql-query-roundtrip* t)
(setf *backend* "http://virtuoso:8890/sparql")

(in-package :server)
(setf *log-incoming-requests-p* nil)

;;;;;;;;;;;;;;;;;
;;; access rights
(in-package :acl)

(defparameter *access-specifications* nil
  "All known ACCESS specifications.")

(defparameter *graphs* nil
  "All known GRAPH-SPECIFICATION instances.")

(defparameter *rights* nil
  "All known GRANT instances connecting ACCESS-SPECIFICATION to GRAPH.")

;; Prefixes used in the constraints below (not in the SPARQL queries)
(define-prefixes
  :adms "http://www.w3.org/ns/adms#"
  :nfo "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
  :ext "http://mu.semte.ch/vocabularies/ext/"
  :foaf "http://xmlns.com/foaf/0.1/"
  :skos "http://www.w3.org/2004/02/skos/core#")

(type-cache::add-type-for-prefix "http://mu.semte.ch/sessions/" "http://mu.semte.ch/vocabularies/session/Session")

(define-graph public ("http://mu.semte.ch/graphs/public")
  ("foaf:Person" -> _)
  ("foaf:OnlineAccount" -> _)
  ("adms:Identifier" -> _)
  ("skos:Concept" -> _))

(define-graph org ("http://mu.semte.ch/graphs/organizations/")
  ("foaf:Person" -> _)
  ("foaf:OnlineAccount" -> _)
  ("adms:Identifier" -> _))

(define-graph complaint-forms ("http://mu.semte.ch/graphs/public")
  ("ext:ComplaintForm" -> _)
  ("nfo:FileDataObject" -> _))


(supply-allowed-group "public")

(supply-allowed-group "logged-in-or-impersonating"
  :parameters ("session_group")
  :query "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
    PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
    SELECT DISTINCT ?session_group WHERE {
      {
      <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group.
      }
    }")

(supply-allowed-group "admin"
  :parameters ()
  :query "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
    PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
    SELECT DISTINCT ?session_group ?session_role WHERE {
      <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group;
                   ext:sessionRole ?session_role.
      FILTER( ?session_role = \"KlachtenformulierGebruiker\" )
    }")


(grant (read)
  :to-graph (public)
  :for-allowed-group "public")

(grant (read)
  :to-graph (org)
  :for-allowed-group "logged-in-or-impersonating")

(grant (write)
    :to-graph (complaint-forms)
    :for-allowed-group "public")

;; Logged in and authorized users can read the complaints and files in the complaint-forms graph
;;
;; /!\ WARNING /!\
;;
;; The name of this Group, `admin`, is used in the dispatcher config as well to shield GET calls to
;; complaints and files and make sure they are only allowed for authorized users, due to how mu-auth/sparql-parser
;; works (mu-auth/sparql-parser doesn't not restrain the resource TYPES that can be *read* from the graph, only the
;; graph itself, which is an issue for this app where some users need to only write and others only read)
(grant (read)
  :to-graph (complaint-forms)
  :for-allowed-group "admin")
