var cs = function(n, ord
) {
  var s = String(n).split('.'), i = s[0], v0 = !s[1];
  if (ord) return 'other';
  return (n == 1 && v0) ? 'one'
      : ((i >= 2 && i <= 4) && v0) ? 'few'
      : (!v0) ? 'many'
      : 'other';
};
var plural = function (value, offset, lcfunc, data, isOrdinal) {
  if ({}.hasOwnProperty.call(data, value)) return data[value];
  if (offset) value -= offset;
  var key = lcfunc(value, isOrdinal);
  return key in data ? data[key] : data.other;
};

(function (root, G) {
  if (typeof define === "function" && define.amd) { define(G); }
  else if (typeof exports === "object") { module.exports = G; }
  else { root.i18nDataAPI = G; }
					SMap._ = function(str, d) { return G[str](d); };
})(this, {
  controlLayer: function(d) { return "Změnit mapu"; },
  controlCopyright: function(d) { return " a <a href=\"#\" data-others=\"1\">další</a>"; },
  controlOrientation: function(d) { return "Otočit"; },
  controlLogo: function(d) { return "Zobrazit na Mapy.com"; },
  panoUnsupported: function(d) { return "3d není podporováno, omlouváme se."; },
  "map.unsupported": function(d) { return "Bohužel používáte starý webový prohlížeč, který nepodporuje mapové API Mapy.com. Zkuste použít jeden z <a href='//napoveda.seznam.cz/cz/podporovane-internetove-prohlizece.html'>podporovaných prohlížečů</a>."; },
  "map.zoomIn": function(d) { return "Přiblížit"; },
  "map.zoomOut": function(d) { return "Oddálit"; },
  "map.move": function(d) { return "Posun mapy"; },
  "map.zooms.world": function(d) { return "Svět"; },
  "map.zooms.states": function(d) { return "Stát"; },
  "map.zooms.districts": function(d) { return "Kraj"; },
  "map.zooms.cities": function(d) { return "Město"; },
  "map.zooms.municipalities": function(d) { return "Obec"; },
  "map.zooms.streets": function(d) { return "Ulice"; },
  "map.zooms.houses": function(d) { return "Dům"; },
  "map.zooms.birdEye": function(d) { return "Ptačí pohled"; },
  "trafficDetail.load": function(d) { return d.load + ". stupeň průjezdnosti"; },
  "trafficDetail.delay": function(d) { return "Předpokládané zdržení je " + plural(d.hours, 0, cs, { "0": "", one: d.hours + " hodina", few: d.hours + " hodiny", other: d.hours + " hodin" }) + plural(d.hours, 0, cs, { "0": plural(d.minutes, 0, cs, { "0": "0 minut", other: "" }), other: plural(d.minutes, 0, cs, { "0": "", other: "\\u0020" }) }) + plural(d.minutes, 0, cs, { "0": "", one: d.minutes + " minuta", few: d.minutes + " minuty", other: d.minutes + " minut" }) + "."; },
  "trafficDetail.speed": function(d) { return plural(d.actSpeed, 0, cs, { "0": "Maximalní povolená rychlost " + d.maxSpeed + " km/h.", other: "Rychlost " + d.actSpeed + " km/h (maximalní povolená " + d.maxSpeed + " km/h)" }); },
  "separators.decimal": function(d) { return ","; },
  "separators.thousand": function(d) { return " "; },
  "mapsetLabel.base": function(d) { return "Obecná"; },
  "mapsetLabel.ophoto": function(d) { return "Letecká"; },
  "mapsetLabel.turist": function(d) { return "Turistická"; },
  "mapsetLabel.geography": function(d) { return "Zeměpisná"; },
  "mapsetLabel.winter": function(d) { return "Zimní"; },
  "mapsetLabel.historic": function(d) { return "Historická"; },
  "mapsetLabel.ophoto0203": function(d) { return "Letecká 03"; },
  "mapsetLabel.ophoto0406": function(d) { return "Letecká 06"; },
  "mapsetLabel.ophoto1415": function(d) { return "Letecká 15"; },
  "mapsetLabel.ophoto1618": function(d) { return "Letecká 18"; },
  "mapsetLabel.summer": function(d) { return "Letní"; },
  "mapsetLabel.ophoto1012": function(d) { return "Letecká 2012"; },
  "mapsetTitle.historic": function(d) { return "Historická 1836–1852"; },
  "mapsetTitle.ophoto0203": function(d) { return "Letecká 2002–2003"; },
  "mapsetTitle.ophoto0406": function(d) { return "Letecká 2004–2006"; },
  "mapsetTitle.ophoto1415": function(d) { return "Letecká 2014–2015"; },
  "mapsetTitle.ophoto1618": function(d) { return "Letecká 2016–2018"; },
  "mapsetTitle.summer": function(d) { return "Letní"; },
  newest: function(d) { return "Nejnovější"; },
  "pano.notAvail": function(d) { return "Pro vámi zvolený rok Panoramu nemáme. Zobrazujeme snímek z roku " + d.year + "."; },
  "pano.contextLost": function(d) { return "Problém se zobrazením panoramy, prosím restartujte prohlížeč a promažte si cookies. Pokud ani toto nepomůže, napište nám přes ikonku Chyba v mapě."; },
  "pano.contextRestore": function(d) { return "Z důvodů nečinnosti prohlížeč pozastavil zobrazení panoramy."; },
  "pano.restoreBtn": function(d) { return "Obnovit panoramu"; },
  "pano.close": function(d) { return "Zavřít"; },
  "pano.error.previewImage": function(d) { return "Nelze načíst náhled panoramy"; },
  "pano.error.missingApiKey": function(d) { return "Chybí API klíč"; },
  "pano.error.wrongApiKey": function(d) { return "Špatný API klíč"; },
  "pano.error.wrongApiKey2": function(d) { return "Neplatný nebo nezadaný API klíč. Pro konzumaci Panorami zadejte platný API klíč."; },
  "pano.error.getBest": function(d) { return "Pro souřadnice lon " + d.lon + ", lat " + d.lat + " s radiusem " + d.radius + " nebyla nalezena žádná panorama"; },
  "pano.error.getDetail": function(d) { return "Pro pid " + d.pid + " nebyla nalezena žádná panorama"; },
  endingConsole: function(d) { return "Používáte zastaralou verzi knihovny JS SDK Mapy.com. Tato knihovna přestane být v blízké době podporována. Doporučujeme přejít na nové REST API Mapy.com. Více informací najdete zde: " + d.link; },
  endingTooltip: function(d) { return "Podpora tohoto API končí" + d.bl + d.date + "."; },
  endingPopup: function(d) { return "Podpora tohoto API končí " + d.date + ". Pro obnovení služby se připojte na nové API."; },
  endingFullscreen: function(d) { return "Podpora JS API byla ukončena " + d.date + ". Pro obnovení služby se připojte na nové API."; },
  endingMoreAboutApi: function(d) { return "Více zde"; },
  endingMoreAboutApi2: function(d) { return "Více informací najdete zde"; },
  endingMoreAboutApiFullscreen: function(d) { return "Chci nové API od Mapy.com"; },
  endingMap: function(d) { return "Tento web používá již nepodporovanou knihovnu pro zobrazení mapy."; },
  endingPano: function(d) { return "Tento web používá již nepodporovanou knihovnu pro zobrazení panoramy."; },
  endingSuggest: function(d) { return "Tento web používá již nepodporovanou knihovnu pro vyhledávání."; },
  endingDevs: function(d) { return "Upozornění pro vývojáře"; }
});