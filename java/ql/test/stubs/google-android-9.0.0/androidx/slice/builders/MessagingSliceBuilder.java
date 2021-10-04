/*
 * Copyright 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package androidx.slice.builders;

import android.content.Context;
import android.graphics.drawable.Icon;
import android.net.Uri;
import androidx.annotation.NonNull;
import androidx.core.graphics.drawable.IconCompat;
import androidx.core.util.Consumer;

public class MessagingSliceBuilder extends TemplateSliceBuilder {
  public MessagingSliceBuilder(@NonNull Context context, @NonNull Uri uri) {
    super(null, null);
  }

  public MessagingSliceBuilder add(MessageBuilder builder) {
    return null;
  }

  public MessagingSliceBuilder add(Consumer<MessageBuilder> c) {
    return null;
  }

  public static final class MessageBuilder extends TemplateSliceBuilder {
    public MessageBuilder(MessagingSliceBuilder parent) {
      super(null, null);
    }

    public MessageBuilder addSource(Icon source) {
      return null;
    }

    public MessageBuilder addSource(IconCompat source) {
      return null;
    }

    public MessageBuilder addText(CharSequence text) {
      return null;
    }

    public MessageBuilder addTimestamp(long timestamp) {
      return null;
    }

  }
}
