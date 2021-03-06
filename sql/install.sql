-- CDN Tax Receipts Extension
-- last change: 0.9.beta1

-- NOTE: We avoid direct foreign keys to CiviCRM schema because this log should
-- remain intact even if a particular contact or contribution is deleted (for
-- auditing purposes).

DROP TABLE IF EXISTS cdntaxreceipts_log_contributions;
DROP TABLE IF EXISTS cdntaxreceipts_log;

--
-- Table structure for table `cdntaxreceipts_log`
--

CREATE TABLE cdntaxreceipts_log (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'The internal id of the issuance.',
  receipt_no varchar(128) NOT NULL  COMMENT 'Receipt Number.',
  issued_on int(11) NOT NULL COMMENT 'Unix timestamp of when the receipt was issued, or re-issued.',
  contact_id int(10) unsigned NOT NULL COMMENT 'CiviCRM contact id to whom the reciept is issued.',
  receipt_amount decimal(10,2) NOT NULL COMMENT 'Receiptable amount, total minus non-recieptable portion.',
  is_duplicate tinyint(4) NOT NULL COMMENT 'Boolean indicating whether this is a re-issue.',
  uid int(10) unsigned NOT NULL COMMENT 'Drupal user id of the person issuing the receipt.',
  ip varchar(128) NOT NULL COMMENT 'IP of the user who issued the reciept.',
  issue_type varchar(16) NOT NULL COMMENT 'The type of receipt (single or annual).',
  issue_method varchar(16) NULL COMMENT 'The send method (email or print).',
  PRIMARY KEY (id),
  INDEX contact_id (contact_id),
  INDEX receipt_no (receipt_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Log file of tax reciept issuing.';


--
-- Table structure for table `cdntaxreceipts_log_contributions`
--

CREATE TABLE cdntaxreceipts_log_contributions (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'The internal id of this line.',
  receipt_id int(11) NOT NULL COMMENT 'The internal receipt ID this line belongs to.',
  contribution_id int(10) unsigned NOT NULL COMMENT 'CiviCRM contribution id for which the reciept is issued.',
  contribution_amount decimal(10,2) DEFAULT NULL COMMENT 'Total contribution amount.',
  receipt_amount decimal(10,2) NOT NULL COMMENT 'Receiptable amount, total minus non-recieptable portion.',
  receive_date datetime NOT NULL COMMENT 'Date on which the contribution was received, redundant information!',
  PRIMARY KEY (id),
  FOREIGN KEY (receipt_id) REFERENCES cdntaxreceipts_log(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contributions for each tax reciept issuing.';

