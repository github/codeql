# coding: utf-8
from __future__ import unicode_literals

import functools
import itertools
import operator
import re

from .common import InfoExtractor
from ..compat import (
    compat_HTTPError,
    compat_str,
    compat_urllib_request,
)
from .openload import PhantomJSwrapper
from ..utils import (
    determine_ext,
    ExtractorError,
    int_or_none,
    NO_DEFAULT,
    orderedSet,
    remove_quotes,
    str_to_int,
    url_or_none,
)


class PornHubBaseIE(InfoExtractor):
    def _download_webpage_handle(self, *args, **kwargs):
        def dl(*args, **kwargs):
            return super(PornHubBaseIE, self)._download_webpage_handle(*args, **kwargs)

        webpage, urlh = dl(*args, **kwargs)

        if any(re.search(p, webpage) for p in (
                r'<body\b[^>]+\bonload=["\']go\(\)',
                r'document\.cookie\s*=\s*["\']RNKEY=',
                r'document\.location\.reload\(true\)')):
            url_or_request = args[0]
            url = (url_or_request.get_full_url()
                   if isinstance(url_or_request, compat_urllib_request.Request)
                   else url_or_request)
            phantom = PhantomJSwrapper(self, required_version='2.0')
            phantom.get(url, html=webpage)
            webpage, urlh = dl(*args, **kwargs)

        return webpage, urlh


class PornHubIE(PornHubBaseIE):
    IE_DESC = 'PornHub and Thumbzilla'
    _VALID_URL = r'''(?x)
                    https?://
                        (?:
                            (?:[^/]+\.)?(?P<host>pornhub(?:premium)?\.(?:com|net))/(?:(?:view_video\.php|video/show)\?viewkey=|embed/)|
                            (?:www\.)?thumbzilla\.com/video/
                        )
                        (?P<id>[\da-z]+)
                    '''
    _TESTS = [{
        'url': 'http://www.pornhub.com/view_video.php?viewkey=648719015',
        'md5': '1e19b41231a02eba417839222ac9d58e',
        'info_dict': {
            'id': '648719015',
            'ext': 'mp4',
            'title': 'Seductive Indian beauty strips down and fingers her pink pussy',
            'uploader': 'Babes',
            'upload_date': '20130628',
            'duration': 361,
            'view_count': int,
            'like_count': int,
            'dislike_count': int,
            'comment_count': int,
            'age_limit': 18,
            'tags': list,
            'categories': list,
        },
    }, {
        # non-ASCII title
        'url': 'http://www.pornhub.com/view_video.php?viewkey=1331683002',
        'info_dict': {
            'id': '1331683002',
            'ext': 'mp4',
            'title': '重庆婷婷女王足交',
            'uploader': 'Unknown',
            'upload_date': '20150213',
            'duration': 1753,
            'view_count': int,
            'like_count': int,
            'dislike_count': int,
            'comment_count': int,
            'age_limit': 18,
            'tags': list,
            'categories': list,
        },
        'params': {
            'skip_download': True,
        },
    }, {
        # subtitles
        'url': 'https://www.pornhub.com/view_video.php?viewkey=ph5af5fef7c2aa7',
        'info_dict': {
            'id': 'ph5af5fef7c2aa7',
            'ext': 'mp4',
            'title': 'BFFS - Cute Teen Girls Share Cock On the Floor',
            'uploader': 'BFFs',
            'duration': 622,
            'view_count': int,
            'like_count': int,
            'dislike_count': int,
            'comment_count': int,
            'age_limit': 18,
            'tags': list,
            'categories': list,
            'subtitles': {
                'en': [{
                    "ext": 'srt'
                }]
            },
        },
        'params': {
            'skip_download': True,
        },
    }, {
        'url': 'http://www.pornhub.com/view_video.php?viewkey=ph557bbb6676d2d',
        'only_matching': True,
    }, {
        # removed at the request of cam4.com
        'url': 'http://fr.pornhub.com/view_video.php?viewkey=ph55ca2f9760862',
        'only_matching': True,
    }, {
        # removed at the request of the copyright owner
        'url': 'http://www.pornhub.com/view_video.php?viewkey=788152859',
        'only_matching': True,
    }, {
        # removed by uploader
        'url': 'http://www.pornhub.com/view_video.php?viewkey=ph572716d15a111',
        'only_matching': True,
    }, {
        # private video
        'url': 'http://www.pornhub.com/view_video.php?viewkey=ph56fd731fce6b7',
        'only_matching': True,
    }, {
        'url': 'https://www.thumbzilla.com/video/ph56c6114abd99a/horny-girlfriend-sex',
        'only_matching': True,
    }, {
        'url': 'http://www.pornhub.com/video/show?viewkey=648719015',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.net/view_video.php?viewkey=203640933',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhubpremium.com/view_video.php?viewkey=ph5e4acdae54a82',
        'only_matching': True,
    }]

    @staticmethod
    def _extract_urls(webpage):
        return re.findall(
            r'<iframe[^>]+?src=["\'](?P<url>(?:https?:)?//(?:www\.)?pornhub\.(?:com|net)/embed/[\da-z]+)',
            webpage)

    def _extract_count(self, pattern, webpage, name):
        return str_to_int(self._search_regex(
            pattern, webpage, '%s count' % name, fatal=False))

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        host = mobj.group('host') or 'pornhub.com'
        video_id = mobj.group('id')

        if 'premium' in host:
            if not self._downloader.params.get('cookiefile'):
                raise ExtractorError(
                    'PornHub Premium requires authentication.'
                    ' You may want to use --cookies.',
                    expected=True)

        self._set_cookie(host, 'age_verified', '1')

        def dl_webpage(platform):
            self._set_cookie(host, 'platform', platform)
            return self._download_webpage(
                'https://www.%s/view_video.php?viewkey=%s' % (host, video_id),
                video_id, 'Downloading %s webpage' % platform)

        webpage = dl_webpage('pc')

        error_msg = self._html_search_regex(
            r'(?s)<div[^>]+class=(["\'])(?:(?!\1).)*\b(?:removed|userMessageSection)\b(?:(?!\1).)*\1[^>]*>(?P<error>.+?)</div>',
            webpage, 'error message', default=None, group='error')
        if error_msg:
            error_msg = re.sub(r'\s+', ' ', error_msg)
            raise ExtractorError(
                'PornHub said: %s' % error_msg,
                expected=True, video_id=video_id)

        # video_title from flashvars contains whitespace instead of non-ASCII (see
        # http://www.pornhub.com/view_video.php?viewkey=1331683002), not relying
        # on that anymore.
        title = self._html_search_meta(
            'twitter:title', webpage, default=None) or self._html_search_regex(
            (r'(?s)<h1[^>]+class=["\']title["\'][^>]*>(?P<title>.+?)</h1>',
             r'<div[^>]+data-video-title=(["\'])(?P<title>(?:(?!\1).)+)\1',
             r'shareTitle["\']\s*[=:]\s*(["\'])(?P<title>(?:(?!\1).)+)\1'),
            webpage, 'title', group='title')

        video_urls = []
        video_urls_set = set()
        subtitles = {}

        flashvars = self._parse_json(
            self._search_regex(
                r'var\s+flashvars_\d+\s*=\s*({.+?});', webpage, 'flashvars', default='{}'),
            video_id)
        if flashvars:
            subtitle_url = url_or_none(flashvars.get('closedCaptionsFile'))
            if subtitle_url:
                subtitles.setdefault('en', []).append({
                    'url': subtitle_url,
                    'ext': 'srt',
                })
            thumbnail = flashvars.get('image_url')
            duration = int_or_none(flashvars.get('video_duration'))
            media_definitions = flashvars.get('mediaDefinitions')
            if isinstance(media_definitions, list):
                for definition in media_definitions:
                    if not isinstance(definition, dict):
                        continue
                    video_url = definition.get('videoUrl')
                    if not video_url or not isinstance(video_url, compat_str):
                        continue
                    if video_url in video_urls_set:
                        continue
                    video_urls_set.add(video_url)
                    video_urls.append(
                        (video_url, int_or_none(definition.get('quality'))))
        else:
            thumbnail, duration = [None] * 2

        def extract_js_vars(webpage, pattern, default=NO_DEFAULT):
            assignments = self._search_regex(
                pattern, webpage, 'encoded url', default=default)
            if not assignments:
                return {}

            assignments = assignments.split(';')

            js_vars = {}

            def parse_js_value(inp):
                inp = re.sub(r'/\*(?:(?!\*/).)*?\*/', '', inp)
                if '+' in inp:
                    inps = inp.split('+')
                    return functools.reduce(
                        operator.concat, map(parse_js_value, inps))
                inp = inp.strip()
                if inp in js_vars:
                    return js_vars[inp]
                return remove_quotes(inp)

            for assn in assignments:
                assn = assn.strip()
                if not assn:
                    continue
                assn = re.sub(r'var\s+', '', assn)
                vname, value = assn.split('=', 1)
                js_vars[vname] = parse_js_value(value)
            return js_vars

        def add_video_url(video_url):
            v_url = url_or_none(video_url)
            if not v_url:
                return
            if v_url in video_urls_set:
                return
            video_urls.append((v_url, None))
            video_urls_set.add(v_url)

        if not video_urls:
            FORMAT_PREFIXES = ('media', 'quality')
            js_vars = extract_js_vars(
                webpage, r'(var\s+(?:%s)_.+)' % '|'.join(FORMAT_PREFIXES),
                default=None)
            if js_vars:
                for key, format_url in js_vars.items():
                    if any(key.startswith(p) for p in FORMAT_PREFIXES):
                        add_video_url(format_url)
            if not video_urls and re.search(
                    r'<[^>]+\bid=["\']lockedPlayer', webpage):
                raise ExtractorError(
                    'Video %s is locked' % video_id, expected=True)

        if not video_urls:
            js_vars = extract_js_vars(
                dl_webpage('tv'), r'(var.+?mediastring.+?)</script>')
            add_video_url(js_vars['mediastring'])

        for mobj in re.finditer(
                r'<a[^>]+\bclass=["\']downloadBtn\b[^>]+\bhref=(["\'])(?P<url>(?:(?!\1).)+)\1',
                webpage):
            video_url = mobj.group('url')
            if video_url not in video_urls_set:
                video_urls.append((video_url, None))
                video_urls_set.add(video_url)

        upload_date = None
        formats = []
        for video_url, height in video_urls:
            if not upload_date:
                upload_date = self._search_regex(
                    r'/(\d{6}/\d{2})/', video_url, 'upload data', default=None)
                if upload_date:
                    upload_date = upload_date.replace('/', '')
            ext = determine_ext(video_url)
            if ext == 'mpd':
                formats.extend(self._extract_mpd_formats(
                    video_url, video_id, mpd_id='dash', fatal=False))
                continue
            elif ext == 'm3u8':
                formats.extend(self._extract_m3u8_formats(
                    video_url, video_id, 'mp4', entry_protocol='m3u8_native',
                    m3u8_id='hls', fatal=False))
                continue
            tbr = None
            mobj = re.search(r'(?P<height>\d+)[pP]?_(?P<tbr>\d+)[kK]', video_url)
            if mobj:
                if not height:
                    height = int(mobj.group('height'))
                tbr = int(mobj.group('tbr'))
            formats.append({
                'url': video_url,
                'format_id': '%dp' % height if height else None,
                'height': height,
                'tbr': tbr,
            })
        self._sort_formats(formats)

        video_uploader = self._html_search_regex(
            r'(?s)From:&nbsp;.+?<(?:a\b[^>]+\bhref=["\']/(?:(?:user|channel)s|model|pornstar)/|span\b[^>]+\bclass=["\']username)[^>]+>(.+?)<',
            webpage, 'uploader', fatal=False)

        view_count = self._extract_count(
            r'<span class="count">([\d,\.]+)</span> views', webpage, 'view')
        like_count = self._extract_count(
            r'<span class="votesUp">([\d,\.]+)</span>', webpage, 'like')
        dislike_count = self._extract_count(
            r'<span class="votesDown">([\d,\.]+)</span>', webpage, 'dislike')
        comment_count = self._extract_count(
            r'All Comments\s*<span>\(([\d,.]+)\)', webpage, 'comment')

        def extract_list(meta_key):
            div = self._search_regex(
                r'(?s)<div[^>]+\bclass=["\'].*?\b%sWrapper[^>]*>(.+?)</div>'
                % meta_key, webpage, meta_key, default=None)
            if div:
                return re.findall(r'<a[^>]+\bhref=[^>]+>([^<]+)', div)

        return {
            'id': video_id,
            'uploader': video_uploader,
            'upload_date': upload_date,
            'title': title,
            'thumbnail': thumbnail,
            'duration': duration,
            'view_count': view_count,
            'like_count': like_count,
            'dislike_count': dislike_count,
            'comment_count': comment_count,
            'formats': formats,
            'age_limit': 18,
            'tags': extract_list('tags'),
            'categories': extract_list('categories'),
            'subtitles': subtitles,
        }


class PornHubPlaylistBaseIE(PornHubBaseIE):
    def _extract_entries(self, webpage, host):
        # Only process container div with main playlist content skipping
        # drop-down menu that uses similar pattern for videos (see
        # https://github.com/ytdl-org/youtube-dl/issues/11594).
        container = self._search_regex(
            r'(?s)(<div[^>]+class=["\']container.+)', webpage,
            'container', default=webpage)

        return [
            self.url_result(
                'http://www.%s/%s' % (host, video_url),
                PornHubIE.ie_key(), video_title=title)
            for video_url, title in orderedSet(re.findall(
                r'href="/?(view_video\.php\?.*\bviewkey=[\da-z]+[^"]*)"[^>]*\s+title="([^"]+)"',
                container))
        ]

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        host = mobj.group('host')
        playlist_id = mobj.group('id')

        webpage = self._download_webpage(url, playlist_id)

        entries = self._extract_entries(webpage, host)

        playlist = self._parse_json(
            self._search_regex(
                r'(?:playlistObject|PLAYLIST_VIEW)\s*=\s*({.+?});', webpage,
                'playlist', default='{}'),
            playlist_id, fatal=False)
        title = playlist.get('title') or self._search_regex(
            r'>Videos\s+in\s+(.+?)\s+[Pp]laylist<', webpage, 'title', fatal=False)

        return self.playlist_result(
            entries, playlist_id, title, playlist.get('description'))


class PornHubUserIE(PornHubPlaylistBaseIE):
    _VALID_URL = r'(?P<url>https?://(?:[^/]+\.)?(?P<host>pornhub(?:premium)?\.(?:com|net))/(?:(?:user|channel)s|model|pornstar)/(?P<id>[^/?#&]+))(?:[?#&]|/(?!videos)|$)'
    _TESTS = [{
        'url': 'https://www.pornhub.com/model/zoe_ph',
        'playlist_mincount': 118,
    }, {
        'url': 'https://www.pornhub.com/pornstar/liz-vicious',
        'info_dict': {
            'id': 'liz-vicious',
        },
        'playlist_mincount': 118,
    }, {
        'url': 'https://www.pornhub.com/users/russianveet69',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/channels/povd',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/model/zoe_ph?abc=1',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        user_id = mobj.group('id')
        return self.url_result(
            '%s/videos' % mobj.group('url'), ie=PornHubPagedVideoListIE.ie_key(),
            video_id=user_id)


class PornHubPagedPlaylistBaseIE(PornHubPlaylistBaseIE):
    @staticmethod
    def _has_more(webpage):
        return re.search(
            r'''(?x)
                <li[^>]+\bclass=["\']page_next|
                <link[^>]+\brel=["\']next|
                <button[^>]+\bid=["\']moreDataBtn
            ''', webpage) is not None

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        host = mobj.group('host')
        item_id = mobj.group('id')

        page = int_or_none(self._search_regex(
            r'\bpage=(\d+)', url, 'page', default=None))

        entries = []
        for page_num in (page, ) if page is not None else itertools.count(1):
            try:
                webpage = self._download_webpage(
                    url, item_id, 'Downloading page %d' % page_num,
                    query={'page': page_num})
            except ExtractorError as e:
                if isinstance(e.cause, compat_HTTPError) and e.cause.code == 404:
                    break
                raise
            page_entries = self._extract_entries(webpage, host)
            if not page_entries:
                break
            entries.extend(page_entries)
            if not self._has_more(webpage):
                break

        return self.playlist_result(orderedSet(entries), item_id)


class PornHubPagedVideoListIE(PornHubPagedPlaylistBaseIE):
    _VALID_URL = r'https?://(?:[^/]+\.)?(?P<host>pornhub(?:premium)?\.(?:com|net))/(?P<id>(?:[^/]+/)*[^/?#&]+)'
    _TESTS = [{
        'url': 'https://www.pornhub.com/model/zoe_ph/videos',
        'only_matching': True,
    }, {
        'url': 'http://www.pornhub.com/users/rushandlia/videos',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/pornstar/jenny-blighe/videos',
        'info_dict': {
            'id': 'pornstar/jenny-blighe/videos',
        },
        'playlist_mincount': 149,
    }, {
        'url': 'https://www.pornhub.com/pornstar/jenny-blighe/videos?page=3',
        'info_dict': {
            'id': 'pornstar/jenny-blighe/videos',
        },
        'playlist_mincount': 40,
    }, {
        # default sorting as Top Rated Videos
        'url': 'https://www.pornhub.com/channels/povd/videos',
        'info_dict': {
            'id': 'channels/povd/videos',
        },
        'playlist_mincount': 293,
    }, {
        # Top Rated Videos
        'url': 'https://www.pornhub.com/channels/povd/videos?o=ra',
        'only_matching': True,
    }, {
        # Most Recent Videos
        'url': 'https://www.pornhub.com/channels/povd/videos?o=da',
        'only_matching': True,
    }, {
        # Most Viewed Videos
        'url': 'https://www.pornhub.com/channels/povd/videos?o=vi',
        'only_matching': True,
    }, {
        'url': 'http://www.pornhub.com/users/zoe_ph/videos/public',
        'only_matching': True,
    }, {
        # Most Viewed Videos
        'url': 'https://www.pornhub.com/pornstar/liz-vicious/videos?o=mv',
        'only_matching': True,
    }, {
        # Top Rated Videos
        'url': 'https://www.pornhub.com/pornstar/liz-vicious/videos?o=tr',
        'only_matching': True,
    }, {
        # Longest Videos
        'url': 'https://www.pornhub.com/pornstar/liz-vicious/videos?o=lg',
        'only_matching': True,
    }, {
        # Newest Videos
        'url': 'https://www.pornhub.com/pornstar/liz-vicious/videos?o=cm',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/pornstar/liz-vicious/videos/paid',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/pornstar/liz-vicious/videos/fanonly',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/video',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/video?page=3',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/video/search?search=123',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/categories/teen',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/categories/teen?page=3',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/hd',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/hd?page=3',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/described-video',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/described-video?page=2',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/video/incategories/60fps-1/hd-porn',
        'only_matching': True,
    }, {
        'url': 'https://www.pornhub.com/playlist/44121572',
        'info_dict': {
            'id': 'playlist/44121572',
        },
        'playlist_mincount': 132,
    }, {
        'url': 'https://www.pornhub.com/playlist/4667351',
        'only_matching': True,
    }, {
        'url': 'https://de.pornhub.com/playlist/4667351',
        'only_matching': True,
    }]

    @classmethod
    def suitable(cls, url):
        return (False
                if PornHubIE.suitable(url) or PornHubUserIE.suitable(url) or PornHubUserVideosUploadIE.suitable(url)
                else super(PornHubPagedVideoListIE, cls).suitable(url))


class PornHubUserVideosUploadIE(PornHubPagedPlaylistBaseIE):
    _VALID_URL = r'(?P<url>https?://(?:[^/]+\.)?(?P<host>pornhub(?:premium)?\.(?:com|net))/(?:(?:user|channel)s|model|pornstar)/(?P<id>[^/]+)/videos/upload)'
    _TESTS = [{
        'url': 'https://www.pornhub.com/pornstar/jenny-blighe/videos/upload',
        'info_dict': {
            'id': 'jenny-blighe',
        },
        'playlist_mincount': 129,
    }, {
        'url': 'https://www.pornhub.com/model/zoe_ph/videos/upload',
        'only_matching': True,
    }]
