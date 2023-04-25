drop table if EXISTS `mccmnclist`; 
CREATE TABLE `mccmnclist` (
`type` int DEFAULT NULL,
`countryName` text,
`countryCode` text,
`mcc` text,
`mnc` text,
`brand` text,
`status` text,
`bands` text,
`notes` text
);
