from __future__ import unicode_literals

import re

from .common import InfoExtractor
from ..compat import (
    compat_urlparse,
    compat_str,
)
from ..utils import (
    ExtractorError,
    determine_ext,
    find_xpath_attr,
    fix_xml_ampersands,
    GeoRestrictedError,
    int_or_none,
    parse_duration,
    strip_or_none,
    try_get,
    unescapeHTML,
    unified_strdate,
    unified_timestamp,
    update_url_query,
    urljoin,
    xpath_text,
)


class RaiBaseIE(InfoExtractor):
    _UUID_RE = r'[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}'
    _GEO_COUNTRIES = ['IT']
    _GEO_BYPASS = False

    def _extract_relinker_info(self, relinker_url, video_id):
        if not re.match(r'https?://', relinker_url):
            return {'formats': [{'url': relinker_url}]}

        formats = []
        geoprotection = None
        is_live = None
        duration = None

        for platform in ('mon', 'flash', 'native'):
            relinker = self._download_xml(
                relinker_url, video_id,
                note='Downloading XML metadata for platform %s' % platform,
                transform_source=fix_xml_ampersands,
                query={'output': 45, 'pl': platform},
                headers=self.geo_verification_headers())

            if not geoprotection:
                geoprotection = xpath_text(
                    relinker, './geoprotection', default=None) == 'Y'

            if not is_live:
                is_live = xpath_text(
                    relinker, './is_live', default=None) == 'Y'
            if not duration:
                duration = parse_duration(xpath_text(
                    relinker, './duration', default=None))

            url_elem = find_xpath_attr(relinker, './url', 'type', 'content')
            if url_elem is None:
                continue

            media_url = url_elem.text

            # This does not imply geo restriction (e.g.
            # http://www.raisport.rai.it/dl/raiSport/media/rassegna-stampa-04a9f4bd-b563-40cf-82a6-aad3529cb4a9.html)
            if media_url == 'http://download.rai.it/video_no_available.mp4':
                continue

            ext = determine_ext(media_url)
            if (ext == 'm3u8' and platform != 'mon') or (ext == 'f4m' and platform != 'flash'):
                continue

            if ext == 'm3u8' or 'format=m3u8' in media_url or platform == 'mon':
                formats.extend(self._extract_m3u8_formats(
                    media_url, video_id, 'mp4', 'm3u8_native',
                    m3u8_id='hls', fatal=False))
            elif ext == 'f4m' or platform == 'flash':
                manifest_url = update_url_query(
                    media_url.replace('manifest#live_hds.f4m', 'manifest.f4m'),
                    {'hdcore': '3.7.0', 'plugin': 'aasp-3.7.0.39.44'})
                formats.extend(self._extract_f4m_formats(
                    manifest_url, video_id, f4m_id='hds', fatal=False))
            else:
                bitrate = int_or_none(xpath_text(relinker, 'bitrate'))
                formats.append({
                    'url': media_url,
                    'tbr': bitrate if bitrate > 0 else None,
                    'format_id': 'http-%d' % bitrate if bitrate > 0 else 'http',
                })

        if not formats and geoprotection is True:
            self.raise_geo_restricted(countries=self._GEO_COUNTRIES)

        return dict((k, v) for k, v in {
            'is_live': is_live,
            'duration': duration,
            'formats': formats,
        }.items() if v is not None)

    @staticmethod
    def _extract_subtitles(url, subtitle_url):
        subtitles = {}
        if subtitle_url and isinstance(subtitle_url, compat_str):
            subtitle_url = urljoin(url, subtitle_url)
            STL_EXT = '.stl'
            SRT_EXT = '.srt'
            subtitles['it'] = [{
                'ext': 'stl',
                'url': subtitle_url,
            }]
            if subtitle_url.endswith(STL_EXT):
                srt_url = subtitle_url[:-len(STL_EXT)] + SRT_EXT
                subtitles['it'].append({
                    'ext': 'srt',
                    'url': srt_url,
                })
        return subtitles


class RaiPlayIE(RaiBaseIE):
    _VALID_URL = r'(?P<url>https?://(?:www\.)?raiplay\.it/.+?-(?P<id>%s)\.html)' % RaiBaseIE._UUID_RE
    _TESTS = [{
        'url': 'http://www.raiplay.it/video/2016/10/La-Casa-Bianca-e06118bb-59a9-4636-b914-498e4cfd2c66.html?source=twitter',
        'md5': '340aa3b7afb54bfd14a8c11786450d76',
        'info_dict': {
            'id': 'e06118bb-59a9-4636-b914-498e4cfd2c66',
            'ext': 'mp4',
            'title': 'La Casa Bianca',
            'alt_title': 'S2016 - Puntata del 23/10/2016',
            'description': 'md5:a09d45890850458077d1f68bb036e0a5',
            'thumbnail': r're:^https?://.*\.jpg$',
            'uploader': 'Rai 3',
            'creator': 'Rai 3',
            'duration': 3278,
            'timestamp': 1477764300,
            'upload_date': '20161029',
            'series': 'La Casa Bianca',
            'season': '2016',
        },
    }, {
        'url': 'http://www.raiplay.it/video/2014/04/Report-del-07042014-cb27157f-9dd0-4aee-b788-b1f67643a391.html',
        'md5': '8970abf8caf8aef4696e7b1f2adfc696',
        'info_dict': {
            'id': 'cb27157f-9dd0-4aee-b788-b1f67643a391',
            'ext': 'mp4',
            'title': 'Report del 07/04/2014',
            'alt_title': 'S2013/14 - Puntata del 07/04/2014',
            'description': 'md5:f27c544694cacb46a078db84ec35d2d9',
            'thumbnail': r're:^https?://.*\.jpg$',
            'uploader': 'Rai 5',
            'creator': 'Rai 5',
            'duration': 6160,
            'series': 'Report',
            'season_number': 5,
            'season': '2013/14',
        },
        'params': {
            'skip_download': True,
        },
    }, {
        'url': 'http://www.raiplay.it/video/2016/11/gazebotraindesi-efebe701-969c-4593-92f3-285f0d1ce750.html?',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        url, video_id = mobj.group('url', 'id')

        media = self._download_json(
            '%s?json' % url, video_id, 'Downloading video JSON')

        title = media['name']

        video = media['video']

        relinker_info = self._extract_relinker_info(video['contentUrl'], video_id)
        self._sort_formats(relinker_info['formats'])

        thumbnails = []
        if 'images' in media:
            for _, value in media.get('images').items():
                if value:
                    thumbnails.append({
                        'url': value.replace('[RESOLUTION]', '600x400')
                    })

        timestamp = unified_timestamp(try_get(
            media, lambda x: x['availabilities'][0]['start'], compat_str))

        subtitles = self._extract_subtitles(url, video.get('subtitles'))

        info = {
            'id': video_id,
            'title': self._live_title(title) if relinker_info.get(
                'is_live') else title,
            'alt_title': media.get('subtitle'),
            'description': media.get('description'),
            'uploader': strip_or_none(media.get('channel')),
            'creator': strip_or_none(media.get('editor')),
            'duration': parse_duration(video.get('duration')),
            'timestamp': timestamp,
            'thumbnails': thumbnails,
            'series': try_get(
                media, lambda x: x['isPartOf']['name'], compat_str),
            'season_number': int_or_none(try_get(
                media, lambda x: x['isPartOf']['numeroStagioni'])),
            'season': media.get('stagione') or None,
            'subtitles': subtitles,
        }

        info.update(relinker_info)
        return info


class RaiPlayLiveIE(RaiBaseIE):
    _VALID_URL = r'https?://(?:www\.)?raiplay\.it/dirette/(?P<id>[^/?#&]+)'
    _TEST = {
        'url': 'http://www.raiplay.it/dirette/rainews24',
        'info_dict': {
            'id': 'd784ad40-e0ae-4a69-aa76-37519d238a9c',
            'display_id': 'rainews24',
            'ext': 'mp4',
            'title': 're:^Diretta di Rai News 24 [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$',
            'description': 'md5:6eca31500550f9376819f174e5644754',
            'uploader': 'Rai News 24',
            'creator': 'Rai News 24',
            'is_live': True,
        },
        'params': {
            'skip_download': True,
        },
    }

    def _real_extract(self, url):
        display_id = self._match_id(url)

        webpage = self._download_webpage(url, display_id)

        video_id = self._search_regex(
            r'data-uniquename=["\']ContentItem-(%s)' % RaiBaseIE._UUID_RE,
            webpage, 'content id')

        return {
            '_type': 'url_transparent',
            'ie_key': RaiPlayIE.ie_key(),
            'url': 'http://www.raiplay.it/dirette/ContentItem-%s.html' % video_id,
            'id': video_id,
            'display_id': display_id,
        }


class RaiPlayPlaylistIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?raiplay\.it/programmi/(?P<id>[^/?#&]+)'
    _TESTS = [{
        'url': 'http://www.raiplay.it/programmi/nondirloalmiocapo/',
        'info_dict': {
            'id': 'nondirloalmiocapo',
            'title': 'Non dirlo al mio capo',
            'description': 'md5:9f3d603b2947c1c7abb098f3b14fac86',
        },
        'playlist_mincount': 12,
    }]

    def _real_extract(self, url):
        playlist_id = self._match_id(url)

        webpage = self._download_webpage(url, playlist_id)

        title = self._html_search_meta(
            ('programma', 'nomeProgramma'), webpage, 'title')
        description = unescapeHTML(self._html_search_meta(
            ('description', 'og:description'), webpage, 'description'))

        entries = []
        for mobj in re.finditer(
                r'<a\b[^>]+\bhref=(["\'])(?P<path>/raiplay/video/.+?)\1',
                webpage):
            video_url = urljoin(url, mobj.group('path'))
            entries.append(self.url_result(
                video_url, ie=RaiPlayIE.ie_key(),
                video_id=RaiPlayIE._match_id(video_url)))

        return self.playlist_result(entries, playlist_id, title, description)


class RaiIE(RaiBaseIE):
    _VALID_URL = r'https?://[^/]+\.(?:rai\.(?:it|tv)|rainews\.it)/.+?-(?P<id>%s)(?:-.+?)?\.html' % RaiBaseIE._UUID_RE
    _TESTS = [{
        # var uniquename = "ContentItem-..."
        # data-id="ContentItem-..."
        'url': 'http://www.raisport.rai.it/dl/raiSport/media/rassegna-stampa-04a9f4bd-b563-40cf-82a6-aad3529cb4a9.html',
        'info_dict': {
            'id': '04a9f4bd-b563-40cf-82a6-aad3529cb4a9',
            'ext': 'mp4',
            'title': 'TG PRIMO TEMPO',
            'thumbnail': r're:^https?://.*\.jpg$',
            'duration': 1758,
            'upload_date': '20140612',
        }
    }, {
        # with ContentItem in many metas
        'url': 'http://www.rainews.it/dl/rainews/media/Weekend-al-cinema-da-Hollywood-arriva-il-thriller-di-Tate-Taylor-La-ragazza-del-treno-1632c009-c843-4836-bb65-80c33084a64b.html',
        'info_dict': {
            'id': '1632c009-c843-4836-bb65-80c33084a64b',
            'ext': 'mp4',
            'title': 'Weekend al cinema, da Hollywood arriva il thriller di Tate Taylor "La ragazza del treno"',
            'description': 'I film in uscita questa settimana.',
            'thumbnail': r're:^https?://.*\.png$',
            'duration': 833,
            'upload_date': '20161103',
        }
    }, {
        # with ContentItem in og:url
        'url': 'http://www.rai.it/dl/RaiTV/programmi/media/ContentItem-efb17665-691c-45d5-a60c-5301333cbb0c.html',
        'md5': '11959b4e44fa74de47011b5799490adf',
        'info_dict': {
            'id': 'efb17665-691c-45d5-a60c-5301333cbb0c',
            'ext': 'mp4',
            'title': 'TG1 ore 20:00 del 03/11/2016',
            'description': 'TG1 edizione integrale ore 20:00 del giorno 03/11/2016',
            'thumbnail': r're:^https?://.*\.jpg$',
            'duration': 2214,
            'upload_date': '20161103',
        }
    }, {
        # drawMediaRaiTV(...)
        'url': 'http://www.report.rai.it/dl/Report/puntata/ContentItem-0c7a664b-d0f4-4b2c-8835-3f82e46f433e.html',
        'md5': '2dd727e61114e1ee9c47f0da6914e178',
        'info_dict': {
            'id': '59d69d28-6bb6-409d-a4b5-ed44096560af',
            'ext': 'mp4',
            'title': 'Il pacco',
            'description': 'md5:4b1afae1364115ce5d78ed83cd2e5b3a',
            'thumbnail': r're:^https?://.*\.jpg$',
            'upload_date': '20141221',
        },
    }, {
        # initEdizione('ContentItem-...'
        'url': 'http://www.tg1.rai.it/dl/tg1/2010/edizioni/ContentSet-9b6e0cba-4bef-4aef-8cf0-9f7f665b7dfb-tg1.html?item=undefined',
        'info_dict': {
            'id': 'c2187016-8484-4e3a-8ac8-35e475b07303',
            'ext': 'mp4',
            'title': r're:TG1 ore \d{2}:\d{2} del \d{2}/\d{2}/\d{4}',
            'duration': 2274,
            'upload_date': '20170401',
        },
        'skip': 'Changes daily',
    }, {
        # HDS live stream with only relinker URL
        'url': 'http://www.rai.tv/dl/RaiTV/dirette/PublishingBlock-1912dbbf-3f96-44c3-b4cf-523681fbacbc.html?channel=EuroNews',
        'info_dict': {
            'id': '1912dbbf-3f96-44c3-b4cf-523681fbacbc',
            'ext': 'flv',
            'title': 'EuroNews',
        },
        'params': {
            'skip_download': True,
        },
    }, {
        # HLS live stream with ContentItem in og:url
        'url': 'http://www.rainews.it/dl/rainews/live/ContentItem-3156f2f2-dc70-4953-8e2f-70d7489d4ce9.html',
        'info_dict': {
            'id': '3156f2f2-dc70-4953-8e2f-70d7489d4ce9',
            'ext': 'mp4',
            'title': 'La diretta di Rainews24',
        },
        'params': {
            'skip_download': True,
        },
    }, {
        # Direct MMS URL
        'url': 'http://www.rai.it/dl/RaiTV/programmi/media/ContentItem-b63a4089-ac28-48cf-bca5-9f5b5bc46df5.html',
        'only_matching': True,
    }, {
        'url': 'https://www.rainews.it/tgr/marche/notiziari/video/2019/02/ContentItem-6ba945a2-889c-4a80-bdeb-8489c70a8db9.html',
        'only_matching': True,
    }]

    def _extract_from_content_id(self, content_id, url):
        media = self._download_json(
            'http://www.rai.tv/dl/RaiTV/programmi/media/ContentItem-%s.html?json' % content_id,
            content_id, 'Downloading video JSON')

        title = media['name'].strip()

        media_type = media['type']
        if 'Audio' in media_type:
            relinker_info = {
                'formats': [{
                    'format_id': media.get('formatoAudio'),
                    'url': media['audioUrl'],
                    'ext': media.get('formatoAudio'),
                }]
            }
        elif 'Video' in media_type:
            relinker_info = self._extract_relinker_info(media['mediaUri'], content_id)
        else:
            raise ExtractorError('not a media file')

        self._sort_formats(relinker_info['formats'])

        thumbnails = []
        for image_type in ('image', 'image_medium', 'image_300'):
            thumbnail_url = media.get(image_type)
            if thumbnail_url:
                thumbnails.append({
                    'url': compat_urlparse.urljoin(url, thumbnail_url),
                })

        subtitles = self._extract_subtitles(url, media.get('subtitlesUrl'))

        info = {
            'id': content_id,
            'title': title,
            'description': strip_or_none(media.get('desc')),
            'thumbnails': thumbnails,
            'uploader': media.get('author'),
            'upload_date': unified_strdate(media.get('date')),
            'duration': parse_duration(media.get('length')),
            'subtitles': subtitles,
        }

        info.update(relinker_info)

        return info

    def _real_extract(self, url):
        video_id = self._match_id(url)

        webpage = self._download_webpage(url, video_id)

        content_item_id = None

        content_item_url = self._html_search_meta(
            ('og:url', 'og:video', 'og:video:secure_url', 'twitter:url',
             'twitter:player', 'jsonlink'), webpage, default=None)
        if content_item_url:
            content_item_id = self._search_regex(
                r'ContentItem-(%s)' % self._UUID_RE, content_item_url,
                'content item id', default=None)

        if not content_item_id:
            content_item_id = self._search_regex(
                r'''(?x)
                    (?:
                        (?:initEdizione|drawMediaRaiTV)\(|
                        <(?:[^>]+\bdata-id|var\s+uniquename)=
                    )
                    (["\'])
                    (?:(?!\1).)*\bContentItem-(?P<id>%s)
                ''' % self._UUID_RE,
                webpage, 'content item id', default=None, group='id')

        content_item_ids = set()
        if content_item_id:
            content_item_ids.add(content_item_id)
        if video_id not in content_item_ids:
            content_item_ids.add(video_id)

        for content_item_id in content_item_ids:
            try:
                return self._extract_from_content_id(content_item_id, url)
            except GeoRestrictedError:
                raise
            except ExtractorError:
                pass

        relinker_url = self._search_regex(
            r'''(?x)
                (?:
                    var\s+videoURL|
                    mediaInfo\.mediaUri
                )\s*=\s*
                ([\'"])
                (?P<url>
                    (?:https?:)?
                    //mediapolis(?:vod)?\.rai\.it/relinker/relinkerServlet\.htm\?
                    (?:(?!\1).)*\bcont=(?:(?!\1).)+)\1
            ''',
            webpage, 'relinker URL', group='url')

        relinker_info = self._extract_relinker_info(
            urljoin(url, relinker_url), video_id)
        self._sort_formats(relinker_info['formats'])

        title = self._search_regex(
            r'var\s+videoTitolo\s*=\s*([\'"])(?P<title>[^\'"]+)\1',
            webpage, 'title', group='title',
            default=None) or self._og_search_title(webpage)

        info = {
            'id': video_id,
            'title': title,
        }

        info.update(relinker_info)

        return info
