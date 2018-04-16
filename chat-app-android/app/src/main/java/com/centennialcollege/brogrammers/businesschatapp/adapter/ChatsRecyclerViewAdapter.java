package com.centennialcollege.brogrammers.businesschatapp.adapter;

import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.centennialcollege.brogrammers.businesschatapp.Constants;
import com.centennialcollege.brogrammers.businesschatapp.R;
import com.centennialcollege.brogrammers.businesschatapp.activity.ChatActivity;
import com.centennialcollege.brogrammers.businesschatapp.model.ChatListItem;
import com.centennialcollege.brogrammers.businesschatapp.model.Message;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * RecyclerView adapter to display the list of chats on personal and group chats list screens.
 */

public class ChatsRecyclerViewAdapter extends RecyclerView.Adapter<ChatsRecyclerViewAdapter.ChatViewHolder> {

    private ArrayList<ChatListItem> chatListItems;

    public ChatsRecyclerViewAdapter(ArrayList<ChatListItem> personalChats) {
        this.chatListItems = personalChats;
    }

    @Override
    public ChatsRecyclerViewAdapter.ChatViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_chat, parent, false);
        return new ChatsRecyclerViewAdapter.ChatViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ChatsRecyclerViewAdapter.ChatViewHolder holder, int position) {
        holder.bind(chatListItems.get(position));
    }

    @Override
    public int getItemCount() {
        return chatListItems.size();
    }

    class ChatViewHolder extends RecyclerView.ViewHolder {
        private TextView tvChatname;
        private TextView tvDate;
        private TextView tvLastMessage;
        private View view;

        ChatViewHolder(View v) {
            super(v);
            view = v;
            tvChatname = v.findViewById(R.id.tv_chat_name);
            tvDate = v.findViewById(R.id.tv_date);
            tvLastMessage = v.findViewById(R.id.tv_last_message);
        }

        void bind(final ChatListItem chat) {

            tvChatname.setText(chat.getChatName());

            Message message = chat.getLastMessage();
            if (message != null) {
                Date date = new Date(message.getMessageTime());
                DateFormat dateFormat = DateFormat.getDateInstance();
                tvDate.setText(dateFormat.format(date));

                tvLastMessage.setText(message.getMessageText());
            }

            view.setOnClickListener(v -> {
                Intent intent = new Intent(view.getContext(), ChatActivity.class);
                intent.putExtra(Constants.KEY_CHAT_ID, chat.getChatId());
                view.getContext().startActivity(intent);
            });
        }
    }
}
