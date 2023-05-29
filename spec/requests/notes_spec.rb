require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  let(:user) { create(:user) }
  let(:note) { create(:note, user:) }

  describe 'GET #index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'assigns @notes' do
      note1 = create(:note, user:)
      note2 = create(:note, user:)

      get :index

      expect(assigns(:notes)).to match_array([note1, note2])
    end

    it 'assigns @pagy' do
      get :index

      expect(assigns(:pagy)).to be_a(Pagy)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before { sign_in user }

      it 'creates a new note' do
        expect do
          post :create, params: { note: { content: 'Test Note' } }
        end.to change(Note, :count).by(1)
      end

      it 'redirect to the page from which the request was made' do
        request.headers['HTTP_REFERER'] = root_path(page: 5)
        post :create, params: { note: { content: 'Test Note' } }

        expect(response).to redirect_to(root_path(page: 5))
      end

      it 'sets the flash notice' do
        post :create, params: { note: { content: 'Test Note' } }

        expect(flash[:notice]).to eq('Note created successfully.')
      end
    end

    context 'when user is not authorized' do
      it 'redirects to sign_in without creating a note' do
        expect do
          post :create, params: { note: { content: 'Test Note' } }
        end.to_not change(Note, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid params' do
      before { sign_in user }

      it 'does not create a new note' do
        expect do
          post :create, params: { note: { content: nil } }, session: { user_id: user.id }
        end.to_not change(Note, :count)
      end

      it 'redirects to first page' do
        request.headers['HTTP_REFERER'] = root_path(page = 'corrupted')
        post :create, params: { note: { content: nil } }, session: { user_id: user.id }

        expect(response).to redirect_to(root_path(page: 1))
      end

      it 'sets the flash alert' do
        post :create, params: { note: { content: nil } }, session: { user_id: user.id }

        expect(flash[:alert]).to eq('Failed to create note.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid params' do
      before { sign_in user }

      it 'deletes the note' do
        note1 = create(:note, user:)

        expect do
          delete :destroy, params: { id: note1.id }
        end.to change(Note, :count).by(-1)
      end

      it 'redirect to the page from which the request was made' do
        request.headers['HTTP_REFERER'] = root_path(page: 2)
        delete :destroy, params: { id: note.id }

        expect(response).to redirect_to(root_path(page: 2))
      end

      it 'sets the flash notice' do
        delete :destroy, params: { id: note.id }

        expect(flash[:notice]).to eq('Note deleted successfully.')
      end
    end

    context 'when user is not authorized' do
      it 'redirects to sign_in without deleting a note' do
        note1 = create(:note, user:)

        expect do
          delete :destroy, params: { id: note1.id }
        end.to_not change(Note, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when a another user tries to delete user`s note' do
      let(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'does not delete the note' do
        note1 = create(:note, user:)

        expect do
          delete :destroy, params: { id: note1.id }
        end.to_not change(Note, :count)
      end

      it 'redirect to root path' do
        request.headers['HTTP_REFERER'] = root_path(page: 3)
        delete :destroy, params: { id: note.id }

        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash alert' do
        delete :destroy, params: { id: note.id }

        expect(flash[:alert]).to eq('Note not found')
      end
    end

    context 'when note is not found' do
      before { sign_in user }

      it 'redirects to root path' do
        delete :destroy, params: { id: 999 }

        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash alert' do
        delete :destroy, params: { id: 999 }

        expect(flash[:alert]).to eq('Note not found')
      end
    end
  end
end
