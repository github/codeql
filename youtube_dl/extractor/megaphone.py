# coding: utf-8
from __future__ import unicode_literals

import re

from .common import InfoExtractor
from ..utils import js_to_json


class MegaphoneIE(InfoExtractor):
    IE_NAME = 'megaphone.fm'
    IE_DESC = 'megaphone.fm embedded players'
    _VALID_URL = r'https://player\.megaphone\.fm/(?P<id>[A-Z0-9]+)'
    _TEST = {
        'url': 'https://player.megaphone.fm/GLT9749789991?"',
        'md5': '4816a0de523eb3e972dc0dda2c191f96',
        'info_dict': {
            'id': 'GLT9749789991',
            'ext': 'mp3',
            'title': '#97 What Kind Of Idiot Gets Phished?',
            'thumbnail': r're:^https://.*\.png.*$',
            'duration': 1776.26375,
            'author': 'Reply All',
        },
    }

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        title = self._og_search_property('audio:title', webpage)
        author = self._og_search_property('audio:artist', webpage)
        thumbnail = self._og_search_thumbnail(webpage)

        episode_json = self._search_regex(r'(?s)var\s+episode\s*=\s*(\{.+?\});', webpage, 'episode JSON')
        episode_data = self._parse_json(episode_json, video_id, js_to_json)
        video_url = self._proto_relative_url(episode_data['mediaUrl'], 'https:')

        formats = [{
            'url': video_url,
        }]

        return {
            'id': video_id,
            'thumbnail': thumbnail,
            'title': title,
            'author': author,
            'duration': episode_data['duration'],
            'formats': formats,
        }

    @classmethod
    def _extract_urls(cls, webpage):
        return [m[0] for m in re.findall(
            r'<iframe[^>]*?\ssrc=["\'](%s)' % cls._VALID_URL, webpage)]
