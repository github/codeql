# coding: utf-8
from __future__ import unicode_literals

from .common import InfoExtractor
from ..utils import int_or_none


class TOnlineIE(InfoExtractor):
    IE_NAME = 't-online.de'
    _VALID_URL = r'https?://(?:www\.)?t-online\.de/tv/(?:[^/]+/)*id_(?P<id>\d+)'
    _TEST = {
        'url': 'http://www.t-online.de/tv/sport/fussball/id_79166266/drittes-remis-zidane-es-muss-etwas-passieren-.html',
        'md5': '7d94dbdde5f9d77c5accc73c39632c29',
        'info_dict': {
            'id': '79166266',
            'ext': 'mp4',
            'title': 'Drittes Remis! Zidane: "Es muss etwas passieren"',
            'description': 'Es läuft nicht rund bei Real Madrid. Das 1:1 gegen den SD Eibar war das dritte Unentschieden in Folge in der Liga.',
        }
    }

    def _real_extract(self, url):
        video_id = self._match_id(url)
        video_data = self._download_json(
            'http://www.t-online.de/tv/id_%s/tid_json_video' % video_id, video_id)
        title = video_data['subtitle']

        formats = []
        for asset in video_data.get('assets', []):
            asset_source = asset.get('source') or asset.get('source2')
            if not asset_source:
                continue
            formats_id = []
            for field_key in ('type', 'profile'):
                field_value = asset.get(field_key)
                if field_value:
                    formats_id.append(field_value)
            formats.append({
                'format_id': '-'.join(formats_id),
                'url': asset_source,
            })

        thumbnails = []
        for image in video_data.get('images', []):
            image_source = image.get('source')
            if not image_source:
                continue
            thumbnails.append({
                'url': image_source,
            })

        return {
            'id': video_id,
            'title': title,
            'description': video_data.get('description'),
            'duration': int_or_none(video_data.get('duration')),
            'thumbnails': thumbnails,
            'formats': formats,
        }
