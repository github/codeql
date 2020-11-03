# coding: utf-8
from __future__ import unicode_literals

from .common import InfoExtractor
from ..utils import (
    xpath_text,
    parse_duration,
    ExtractorError,
)


class EyedoTVIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?eyedo\.tv/[^/]+/(?:#!/)?Live/Detail/(?P<id>[0-9]+)'
    _TEST = {
        'url': 'https://www.eyedo.tv/en-US/#!/Live/Detail/16301',
        'md5': 'ba14f17995cdfc20c36ba40e21bf73f7',
        'info_dict': {
            'id': '16301',
            'ext': 'mp4',
            'title': 'Journée du conseil scientifique de l\'Afnic 2015',
            'description': 'md5:4abe07293b2f73efc6e1c37028d58c98',
            'uploader': 'Afnic Live',
            'uploader_id': '8023',
        }
    }
    _ROOT_URL = 'http://live.eyedo.net:1935/'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        video_data = self._download_xml('http://eyedo.tv/api/live/GetLive/%s' % video_id, video_id)

        def _add_ns(path):
            return self._xpath_ns(path, 'http://schemas.datacontract.org/2004/07/EyeDo.Core.Implementation.Web.ViewModels.Api')

        title = xpath_text(video_data, _add_ns('Titre'), 'title', True)
        state_live_code = xpath_text(video_data, _add_ns('StateLiveCode'), 'title', True)
        if state_live_code == 'avenir':
            raise ExtractorError(
                '%s said: We\'re sorry, but this video is not yet available.' % self.IE_NAME,
                expected=True)

        is_live = state_live_code == 'live'
        m3u8_url = None
        # http://eyedo.tv/Content/Html5/Scripts/html5view.js
        if is_live:
            if xpath_text(video_data, 'Cdn') == 'true':
                m3u8_url = 'http://rrr.sz.xlcdn.com/?account=eyedo&file=A%s&type=live&service=wowza&protocol=http&output=playlist.m3u8' % video_id
            else:
                m3u8_url = self._ROOT_URL + 'w/%s/eyedo_720p/playlist.m3u8' % video_id
        else:
            m3u8_url = self._ROOT_URL + 'replay-w/%s/mp4:%s.mp4/playlist.m3u8' % (video_id, video_id)

        return {
            'id': video_id,
            'title': title,
            'formats': self._extract_m3u8_formats(
                m3u8_url, video_id, 'mp4', 'm3u8_native'),
            'description': xpath_text(video_data, _add_ns('Description')),
            'duration': parse_duration(xpath_text(video_data, _add_ns('Duration'))),
            'uploader': xpath_text(video_data, _add_ns('Createur')),
            'uploader_id': xpath_text(video_data, _add_ns('CreateurId')),
            'chapter': xpath_text(video_data, _add_ns('ChapitreTitre')),
            'chapter_id': xpath_text(video_data, _add_ns('ChapitreId')),
        }
