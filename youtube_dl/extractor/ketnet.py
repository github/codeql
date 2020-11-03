from __future__ import unicode_literals

from .canvas import CanvasIE
from .common import InfoExtractor


class KetnetIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?ketnet\.be/(?:[^/]+/)*(?P<id>[^/?#&]+)'
    _TESTS = [{
        'url': 'https://www.ketnet.be/kijken/zomerse-filmpjes',
        'md5': '6bdeb65998930251bbd1c510750edba9',
        'info_dict': {
            'id': 'zomerse-filmpjes',
            'ext': 'mp4',
            'title': 'Gluur mee op de filmset en op Pennenzakkenrock',
            'description': 'Gluur mee met Ghost Rockers op de filmset',
            'thumbnail': r're:^https?://.*\.jpg$',
        }
    }, {
        # mzid in playerConfig instead of sources
        'url': 'https://www.ketnet.be/kijken/nachtwacht/de-greystook',
        'md5': '90139b746a0a9bd7bb631283f6e2a64e',
        'info_dict': {
            'id': 'md-ast-4ac54990-ce66-4d00-a8ca-9eac86f4c475',
            'display_id': 'md-ast-4ac54990-ce66-4d00-a8ca-9eac86f4c475',
            'ext': 'flv',
            'title': 'Nachtwacht: De Greystook',
            'description': 'md5:1db3f5dc4c7109c821261e7512975be7',
            'thumbnail': r're:^https?://.*\.jpg$',
            'duration': 1468.03,
        },
        'expected_warnings': ['is not a supported codec', 'Unknown MIME type'],
    }, {
        'url': 'https://www.ketnet.be/kijken/karrewiet/uitzending-8-september-2016',
        'only_matching': True,
    }, {
        'url': 'https://www.ketnet.be/achter-de-schermen/sien-repeteert-voor-stars-for-life',
        'only_matching': True,
    }, {
        # mzsource, geo restricted to Belgium
        'url': 'https://www.ketnet.be/kijken/nachtwacht/de-bermadoe',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        video_id = self._match_id(url)

        webpage = self._download_webpage(url, video_id)

        config = self._parse_json(
            self._search_regex(
                r'(?s)playerConfig\s*=\s*({.+?})\s*;', webpage,
                'player config'),
            video_id)

        mzid = config.get('mzid')
        if mzid:
            return self.url_result(
                'https://mediazone.vrt.be/api/v1/ketnet/assets/%s' % mzid,
                CanvasIE.ie_key(), video_id=mzid)

        title = config['title']

        formats = []
        for source_key in ('', 'mz'):
            source = config.get('%ssource' % source_key)
            if not isinstance(source, dict):
                continue
            for format_id, format_url in source.items():
                if format_id == 'hls':
                    formats.extend(self._extract_m3u8_formats(
                        format_url, video_id, 'mp4',
                        entry_protocol='m3u8_native', m3u8_id=format_id,
                        fatal=False))
                elif format_id == 'hds':
                    formats.extend(self._extract_f4m_formats(
                        format_url, video_id, f4m_id=format_id, fatal=False))
                else:
                    formats.append({
                        'url': format_url,
                        'format_id': format_id,
                    })
        self._sort_formats(formats)

        return {
            'id': video_id,
            'title': title,
            'description': config.get('description'),
            'thumbnail': config.get('image'),
            'series': config.get('program'),
            'episode': config.get('episode'),
            'formats': formats,
        }
